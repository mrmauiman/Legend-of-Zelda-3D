@tool
extends Enemy

@onready var animation_player: AnimationPlayer = %LeeverModel/AnimationPlayer;

var link = null;
var time: float = 0;
var timer: float = 0;
var current_rot_accel = 0;
var vel: Vector3;
var stun_timer: float = 0;

const COLLIDER_OFFSET: Vector3 = Vector3(0, 0.8, 0);
const MIN_UNDERGROUND_TIME: float = 1.2;
const MAX_UNDERGROUND_TIME: float = 5;
const ROTATION_SPEED: float = 720;
const ROT_ACCEL_TIME: float = 1;

enum STATES {UNDERGROUND, ABOVEGROUND, HURT, STUNNED};
var state: STATES = STATES.UNDERGROUND;

@onready var angle: float = deg_to_rad(randf_range(-45, 45));


func set_underground_time():
	time = randf_range(MIN_UNDERGROUND_TIME, MAX_UNDERGROUND_TIME);

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
	%BodyShape.disabled = disabled;
	%HurtBoxShape.disabled = disabled;
	%HitBoxShape.disabled = disabled;


func update_held_item():
	pass

func _ready():
	%Sight.global_position = global_position;
	if Engine.is_editor_hint():
		%CollisionDetector.global_position = global_position + COLLIDER_OFFSET;
		return;
	set_underground_time();
	timer = randf_range(0, time);
	animation_player.animation_finished.connect(_animation_finished);
	disable_shapes(true);

var was_on_floor := true;

func _physics_process(delta):
	if Engine.is_editor_hint():
		%Sight.global_position = global_position;
		%CollisionDetector.global_position = global_position + COLLIDER_OFFSET;
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
	
	if state == STATES.UNDERGROUND:
		if link != null:
			%CollisionDetector.global_position = link.global_position + COLLIDER_OFFSET;
			var forward_vec: Vector3 = link.get_forward()
			forward_vec = forward_vec.rotated(Vector3.UP, angle).normalized();
			%CollisionDetector.target_position = (forward_vec * 5.6);
			timer += delta;
			if timer >= time:
				var mul = 4.8;
				if %CollisionDetector.is_colliding():
					var point = %CollisionDetector.get_collision_point();
					var dist = (point - link.global_position).length() - 0.8;
					if dist < 1.6: mul = -4.8;
					else: mul = dist;
				global_position = link.global_position + (forward_vec * mul);
				look_at(global_position - forward_vec);
				vel = -forward_vec * 9.6 * sign(mul);
				animation_player.play("emerge");
				state = STATES.ABOVEGROUND;
				current_rot_accel = 0;
				timer = 0;
				disable_shapes(false);
	if state == STATES.ABOVEGROUND and not animation_player.is_playing():
		current_rot_accel = min(current_rot_accel + delta, ROT_ACCEL_TIME);
		var weight = ease_in(current_rot_accel/ROT_ACCEL_TIME);
		velocity = Vector3.ZERO.lerp(vel, weight)
		%LeeverModel.rotation_degrees.y += (lerpf(0, ROTATION_SPEED, weight)) * delta;
		timer += delta;
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
