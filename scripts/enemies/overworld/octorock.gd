@tool
extends Enemy

@export var turn_chance: int = 4;
@export var shoot_chance: int = 3;
@export var turn_frequency: float = 1;
@export var speed: float = 4.8;
@export var gravity: float = 10;
const TERMINAL_VELOCITY: float = -120;

@onready var animation_player: AnimationPlayer = %OctorockModel/AnimationPlayer;
@onready var wall_checks: Node3D = %WallChecks;

enum STATES {MOVE, SHOOT, HURT, STUNNED, SPAWNING};
var state: STATES = STATES.SPAWNING;

var timer: float = 0;
var stun_timer: float = 0;
var dir: Vector3 = Vector3.ZERO;

var food;

const LINK_PROXIMITY_NULLIFICATION: float = 4.8;

@onready var screen = get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = screen.get_node("SpawnChecker")


func update_held_item():
	pass

func spawned():
	state = STATES.MOVE;

func get_move_dir():
	var available = [];
	for ray: ShapeCast3D in wall_checks.get_children():
		if not ray.is_colliding():
			available.push_back(ray.target_position.normalized());
	if len(available) == 0: return dir;
	return available.pick_random();

func _ready():
	%WallChecks.global_position = global_position;
	if Engine.is_editor_hint():
		return;
	
	animation_player.animation_finished.connect(animation_finished);
	dir = get_move_dir();
	#queue_free();

func animation_finished(_anim):
	if state == STATES.SHOOT:
		state = STATES.MOVE;
	if state == STATES.HURT:
		if stun_timer > 0:
			velocity = Vector3.ZERO;
			state = STATES.STUNNED;
		else:
			state = STATES.MOVE;

func shoot():
	animation_player.play("shoot");
	state = STATES.SHOOT;
	velocity = Vector3.UP * velocity.y;

func set_food(p_food):
	food = p_food;

func _physics_process(delta):
	%WallChecks.global_position = global_position;
	if Engine.is_editor_hint():
		return;

	if state == STATES.SPAWNING: return;

	if clock_stun: 
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;

	var grav_vec = Vector3.UP * max(velocity.y - gravity, TERMINAL_VELOCITY);
	if state == STATES.MOVE:
		if food:
			var dist_to_food = global_position.distance_to(food.global_position);
			if dist_to_food > 1:
				dir = (food.global_position - global_position);
				dir.y = 0;
				dir = dir.normalized();
			else:
				velocity = Vector3.ZERO;
				look_at(food.global_position);
				animation_player.play("eat");
				food.take_bite(delta);
				return;
		look_at(global_position + dir);
		velocity = (dir * speed);
		animation_player.play("walk");
		
		timer += delta;
		if timer >= turn_frequency:
			if randi_range(1, turn_chance) == turn_chance:
				dir = get_move_dir();
			elif randi_range(1, shoot_chance)  == shoot_chance:
				shoot();
			timer = 0;
		if is_on_wall():
			if get_wall_normal().angle_to(-dir) < deg_to_rad(80):
				dir = get_move_dir();
	
	if state == STATES.STUNNED:
		stun_timer = max(stun_timer - delta, 0);
		if stun_timer == 0:
			state = STATES.MOVE;
	
	velocity += grav_vec;
	move_and_slide();


func _on_hurt_box_area_entered(area):
	if area is HitBox and state != STATES.HURT:
		var hitbox: HitBox = area;
		state = STATES.HURT;
		animation_player.play("hurt");
		var knockback = hitbox.knockback;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var kb_dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			kb_dir.y = 0;
			var xz_knockback = xz_speed * kb_dir.normalized();
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
	velocity = (global_transform.basis.z * speed) + (Vector3.UP * speed*2);
	stun_timer = 0.5;

func parried(_by):
	state = STATES.HURT;
	animation_player.play("hurt");
	velocity = (global_transform.basis.z * speed*2) + (Vector3.UP * speed*2);
	stun_timer = 3;
