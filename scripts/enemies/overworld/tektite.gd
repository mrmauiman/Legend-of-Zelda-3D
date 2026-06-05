extends Enemy

@onready var animation_player: AnimationPlayer = %TektiteModel/AnimationPlayer;
@onready var model: Node3D = %TektiteModel;

@export var max_idle_time: float = 4;
@export var jump_power: float = 25.6;
@export var move_speed: float = 9.6;

const GRAVITY: float = 64;
const ANIM_JUMP_POSITION: float = 0.6;
const LINK_PROXIMITY_NULLIFICATION: float = 4.8;

@onready var screen = get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = screen.get_node("SpawnChecker")

enum STATES {IDLE, JUMPING, HURT, STUNNED, SPAWNING};
var state: STATES = STATES.SPAWNING;

var timer: float = 0;
var stun_timer: float = 0;


func update_held_item():
	pass

func spawned():
	state = STATES.IDLE;
	$HitBox/CollisionShape3D.set_deferred("disabled", false);

func set_timer():
	timer = randf_range(0, max_idle_time);

func jump():
	animation_player.play("jump");
	state = STATES.JUMPING;

func align_model_to_vec(vec: Vector3):
	var current_forward = transform.basis.z;
	var new_right = current_forward.cross(vec).normalized();
	var new_forward = vec.cross(new_right).normalized();
	var new_basis = Basis(new_right, vec, -new_forward);
	global_transform.basis = new_basis.orthonormalized();

func get_average_floor_normal():
	var count = %FloorCast.get_collision_count();
	var normal = Vector3.ZERO;
	var new_count = 0;
	for i in range(0, count):
		var new_norm = %FloorCast.get_collision_normal(i);
		if new_norm.y > 0:
			normal += new_norm;
			new_count += 1;
	if normal == Vector3.ZERO:
		return Vector3.UP;
	return normal/new_count;

func align_model_to_floor():
	if %FloorCast.is_colliding():
		var normal = get_average_floor_normal();
		if model.global_transform.basis.y.normalized().angle_to(normal) > deg_to_rad(5):
			#var current_right = transform.basis.x;
			align_model_to_vec(normal);

func align_model_to_up():
	if model.global_transform.basis.y.normalized().angle_to(Vector3.UP) > deg_to_rad(5):
		align_model_to_vec(Vector3.UP);

func idle_process(delta):
	animation_player.play("idle");
	velocity.x = 0;
	velocity.z = 0;
	timer -= delta;
	if timer <= 0:
		jump();
	
	align_model_to_floor()

func jump_process():
	var on_floor: bool = is_on_floor();
	if not %FloorCast.is_colliding():
		align_model_to_up();
	else:
		align_model_to_floor();
	if animation_player.is_playing() and animation_player.current_animation == "jump":
		if  animation_player.current_animation_position >= ANIM_JUMP_POSITION and velocity.y <= 0:
			velocity.y = jump_power;
			velocity.x = randf_range(-move_speed, move_speed);
			velocity.z = randf_range(-move_speed, move_speed);
			var look_dir = velocity;
			look_dir.y = 0;
			look_at(global_position + -look_dir.normalized());
	elif on_floor:
		animation_player.play("land");
		velocity.x = 0;
		velocity.z = 0;

func _ready():
	set_timer();
	animation_player.animation_finished.connect(_animation_finished);

func _physics_process(delta):
	
	if state == STATES.SPAWNING: return;
	
	if clock_stun: 
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;

	velocity.y -= GRAVITY * delta;
	
	match(state):
		STATES.IDLE:
			idle_process(delta);
		STATES.JUMPING:
			jump_process()
		STATES.HURT:
			pass
		STATES.STUNNED:
			velocity.x = 0;
			velocity.z = 0;
			stun_timer -= delta;
			if stun_timer <= 0:
				state = STATES.IDLE;
				set_timer();
	
	move_and_slide();

func _animation_finished(anim):
	if anim == "land" and state == STATES.JUMPING:
		state = STATES.IDLE;
		set_timer();
	
	if state == STATES.HURT:
		velocity.x = 0;
		velocity.z = 0;
		if stun_timer > 0:
			animation_player.stop();
			state = STATES.STUNNED;
		elif is_on_floor():
			state = STATES.IDLE;
			set_timer();
		else:
			state = STATES.JUMPING;


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
