@tool
extends Enemy

enum STATES {SPAWNING, PATROL, HURT, STUNNED};
var state: STATES = STATES.SPAWNING;

@export var turn_chance: float = 35;
@export var move_speed: float = 6.4;

@onready var wall_checks = %WallChecks;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;

var move_dir = Vector3.ZERO;

var timer: float = 1;
var stun_timer: float = 0;

var grave = null;

func change_dir() -> bool:
	return randf_range(0, 100) <= turn_chance;

func get_move_dir():
	var available = [Vector3.ZERO];
	for check: RayCast3D in wall_checks.get_children():
		if not check.is_colliding():
			available.push_back(check.target_position);
	var dir = available.pick_random().normalized();
	
	dir.y = randf_range(-5, 2);
	dir.y = clamp(dir.y, -1, 1);
	
	return dir;

func patrol_process(delta):
	animation_player.play("idle");
	timer -= delta;
	if timer <= 0:
		if change_dir(): move_dir = get_move_dir();
		timer = 1;
	
	var look_dir = move_dir;
	look_dir.y = 0;
	if look_dir.length() > 0:
		look_at(global_position - look_dir.normalized());
	
	velocity = move_dir * move_speed;
	if not %FloorCheck.is_colliding():
		velocity.y = min(velocity.y, 0);

func _ready():
	if Engine.is_editor_hint():
		wall_checks.position = global_position;
		return;
	move_dir = get_move_dir();

func _physics_process(delta):
	wall_checks.position = global_position;
	if Engine.is_editor_hint():
		return;
	
	if clock_stun: 
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;

	match (state):
		STATES.SPAWNING:
			velocity = Vector3.ZERO;
		STATES.PATROL:
			patrol_process(delta);
		STATES.HURT:
			velocity = Vector3.ZERO;
		STATES.STUNNED:
			velocity = Vector3.ZERO;
			stun_timer -= delta;
			if stun_timer <= 0:
				state = STATES.PATROL;
	
	move_and_slide();
	
	var last_collision = get_last_slide_collision();
	if last_collision and last_collision.get_normal().angle_to(Vector3.UP) > deg_to_rad(5):
		move_dir = get_move_dir();

func _animation_finished(_anim):
	if state == STATES.HURT:
		if stun_timer > 0:
			state = STATES.STUNNED;
		else:
			state = STATES.PATROL;
	elif state == STATES.SPAWNING:
		state = STATES.PATROL;

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
			grave = null;
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);

func _exit_tree():
	if grave:
		grave.spawned = false;


func update_held_item():
	pass
