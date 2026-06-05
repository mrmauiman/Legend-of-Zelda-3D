class_name PhaseState extends State

@onready var obstacle_checker: Area3D = get_node("ObstacleChecker");

@export var move_speed: float = 4.8;
@export var min_time: float = 1;

var timer: float = min_time;
var dir: Vector3;
var available_dirs = [
	Vector3(1, 0, 0),
	Vector3(1, 0, 1).normalized(),
	Vector3(0, 0, 1),
	Vector3(-1, 0, 1).normalized(),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, -1).normalized(),
	Vector3(0, 0, -1),
	Vector3(1, 0, -1).normalized(),
];

func set_dir():
	dir = available_dirs.pick_random();

func can_stop():
	var obstacles = obstacle_checker.get_overlapping_bodies();
	return len(obstacles) == 0;

func enter(_previous_state: State, _params: Array):
	character.transparency_animation_player.play("flash");
	set_dir();
	character.set_collision_mask_value(6, false);
	character.set_collision_mask_value(7, false);
	character.set_collision_layer_value(7, false);
	timer = min_time;

func exit(_new_state: State):
	character.transparency_animation_player.play("idle");
	character.set_collision_mask_value(6, true);
	character.set_collision_mask_value(7, true);
	character.set_collision_layer_value(7, true);

func update(_delta):
	pass;

func physics_update(delta):
	if dir == Vector3.ZERO: return;
	
	timer -= delta;
	if timer <= 0 and can_stop():
		state_machine.change_state("Patrol");
	
	var vel = dir * move_speed;
	character.velocity.x = vel.x;
	character.velocity.z = vel.z;
	character.look_at(character.global_position - dir);
	
	if character.is_on_wall():
		var wall_norm = character.get_wall_normal();
		if (-character.basis.z).normalized().angle_to(wall_norm) < deg_to_rad(90):
			dir = dir.bounce(wall_norm);
