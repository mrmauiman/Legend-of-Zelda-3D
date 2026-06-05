@tool
class_name FlyingEnemyPatrolState extends State

@export var turn_chance: float = 45;
@export var stop_chance: float = 50;
@export var move_speed: float = 12.8;

@onready var wall_checks: Node3D = %WallChecks;

var timer: float = 0;
var move_dir = Vector3.ZERO;
var current_speed: float = 0;

func change_dir() -> bool:
	return randf_range(0, 100) <= turn_chance;

func can_stop() -> bool:
	return randf_range(0, 100) <= stop_chance;

func get_move_dir():
	var available = [];
	if can_stop():
		available.push_back(Vector3.ZERO);
	for check: RayCast3D in wall_checks.get_children():
		if not check.is_colliding():
			available.push_back(check.target_position);
	var dir = available.pick_random().normalized();
	
	dir.y = randf_range(-5, 2);
	dir.y = clamp(dir.y, -1, 1);
	
	return dir;
	

func enter(_previous_state: State, _params: Array):
	pass;

func exit(_new_state: State):
	pass;

func update(delta):
	timer -= delta;
	if timer <= 0:
		if change_dir(): move_dir = get_move_dir();
		timer = 1;
	
	var look_dir = move_dir;
	look_dir.y = 0;
	if look_dir.length() > 0:
		character.look_at(global_position - look_dir.normalized());
	

func physics_update(delta):
	current_speed = character.get_real_velocity().length();
	current_speed = min(current_speed + (move_speed * delta), move_speed);
	character.velocity = move_dir * current_speed;

	if not %FloorCheck.is_colliding():
		character.velocity.y = min(character.velocity.y, 0);

	if character.get_real_velocity().length() > 0 or not character.is_on_floor():
		if character.animation_player:
			character.animation_player.play("flap");
	else:
		if character.animation_player:
			character.animation_player.play("idle");

	var last_collision = character.get_last_slide_collision();
	if last_collision and last_collision.get_normal().angle_to(Vector3.UP) > deg_to_rad(5):
		move_dir = get_move_dir();


func _physics_process(_delta):
	wall_checks.position = global_position;
	if Engine.is_editor_hint():
		return;
