@tool
extends Enemy

@onready var animation_player: AnimationPlayer = %LeeverModel/AnimationPlayer;


@export var min_underground_time: float = 1.2;
@export var max_underground_time: float = 2.5;
@export var rotation_speed: float = 720;
@export var rot_accel_time: float = 1;
@export var move_speed: float = 9.6;

var link = null;
var time: float = 0;
var timer: float = 0;
var current_rot_accel = 0;
var vel: Vector3;
var stun_timer: float = 0;

enum STATES {UNDERGROUND, ABOVEGROUND, HURT, STUNNED};
var state: STATES = STATES.UNDERGROUND;

func set_underground_time():
	time = randf_range(min_underground_time, max_underground_time);

func ease_in(x: float) -> float:
	return x * x;

func _animation_finished(_anim):
	if state == STATES.HURT:
		if stun_timer > 0:
			velocity.x = 0;
			velocity.z = 0;
			state = STATES.STUNNED;
		else:
			state = STATES.ABOVEGROUND;

func disable_shapes(disabled):
	collision_layer = 0 if disabled else 0b100;
	%HurtBoxShape.disabled = disabled;
	%HitBoxShape.disabled = disabled;

func set_random_direction():
	var min_x = 0 if %XNeg.is_colliding() else -1;
	var max_x = 0 if %XPos.is_colliding() else 1;
	var min_z = 0 if %ZNeg.is_colliding() else -1;
	var max_z = 0 if %ZPos.is_colliding() else 1;
		
	vel = Vector3(randf_range(min_x, max_x), 0, randf_range(min_z, max_z)).normalized();
	if vel.length() == 0: vel = Vector3.FORWARD;


func update_held_item():
	pass

func _ready():
	%Sight.global_position = global_position;
	if Engine.is_editor_hint():
		return;
	set_underground_time();
	timer = randf_range(0, time);
	animation_player.animation_finished.connect(_animation_finished);
	disable_shapes(true);
	set_random_direction();

var was_on_floor := true;

func _physics_process(delta):
	%WallCheckers.global_position = global_position + (Vector3.UP * 0.8);
	if Engine.is_editor_hint():
		%Sight.global_position = global_position;
		return;
	
	if clock_stun: 
		if state == STATES.UNDERGROUND and animation_player.current_animation != "emerge":
			disable_shapes(false);
			animation_player.play("emerge");
			state = STATES.ABOVEGROUND;
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;
	elif animation_player.current_animation == "emerge":
		if not link:
			state = STATES.UNDERGROUND;
			animation_player.play("disapear");
	
	if state == STATES.UNDERGROUND and not animation_player.is_playing():
		if link != null:
			timer += delta;
			if timer >= time:
				set_random_direction();
				look_at(global_position + vel);
				animation_player.play("emerge");
				state = STATES.ABOVEGROUND;
				current_rot_accel = 0;
				timer = 0;
				disable_shapes(false);
			velocity = vel * move_speed;
			move_and_slide();
	if state == STATES.ABOVEGROUND and not animation_player.is_playing():
		current_rot_accel = min(current_rot_accel + delta, rot_accel_time);
		var weight = ease_in(current_rot_accel/rot_accel_time);
		velocity = Vector3.ZERO.lerp(vel, weight) * move_speed;
		%LeeverModel.rotation_degrees.y += (lerpf(0, rotation_speed, weight)) * delta;timer += delta;
		if timer >= 1.5:
			animation_player.play("disapear");
			state = STATES.UNDERGROUND;
			timer = 0;
			set_underground_time();
			velocity = Vector3.ZERO;
			disable_shapes(true);
		velocity.y = max(velocity.y - (128 * delta), -64);
		move_and_slide();
	
	if state == STATES.HURT:
		velocity.y = max(velocity.y - (128 * delta), -64);
		move_and_slide();
	
	if state == STATES.STUNNED:
		velocity.y = max(velocity.y - (128 * delta), -64);
		stun_timer -= delta;
		if stun_timer <= 0:
			stun_timer = 0;
			state = STATES.ABOVEGROUND;
		move_and_slide();

func _on_sight_body_entered(body):
	if body.is_in_group("Link"):
		link = body;

func _on_sight_body_exited(body):
	if body.is_in_group("Link"):
		link = null;


func _on_hurt_box_area_entered(area):
	if area is HitBox and state != STATES.HURT:
		var hitbox: HitBox = area;
		state = STATES.HURT;
		animation_player.play("hurt");
		var knockback = hitbox.knockback;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			dir.y = 0;
			var xz_knockback = xz_speed * dir.normalized();
			knockback = Vector3(xz_knockback.x, hitbox.knockback.y, xz_knockback.z);
		elif hitbox.relative_knockback_orientor:
			var orientor_forward = -hitbox.relative_knockback_orientor.global_transform.basis.z;
			var orientor_right = hitbox.relative_knockback_orientor.global_transform.basis.x;
			knockback = (orientor_forward * knockback.z) + (orientor_right * knockback.x) + (Vector3.UP * knockback.y);
		velocity = knockback;
		stun_timer = hitbox.stun_time;
		%Health.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		if %Health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);

func blocked(_by):
	state = STATES.STUNNED;
	velocity = (global_transform.basis.z * vel.length()) + (Vector3.UP * vel.length()*2);
	stun_timer = 0.5;

func parried(_by):
	state = STATES.HURT;
	animation_player.play("hurt");
	velocity = (global_transform.basis.z * vel.length()*2) + (Vector3.UP * vel.length()*2);
	stun_timer = 3;
