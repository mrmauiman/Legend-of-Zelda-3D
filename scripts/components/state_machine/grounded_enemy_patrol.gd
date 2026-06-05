class_name GroundedEnemyPatrolState extends State


@export var look_at_movement_dir: bool = true;
@export var can_stop: bool = true;
@export var move_speed: float = 4.8;
## Chance out of 100 the armos will turn every second
@export_range(0, 100, 1) var turn_chance: float = 25;

var dir: Vector3;
var timer: float = 1;

func get_patrol_dir():
	var available = [];
	if can_stop:
		available.push_back(Vector3.ZERO);
	for ray: RayCast3D in %WallChecks.get_children():
		if not ray.is_colliding():
			available.push_back(ray.target_position.normalized());
	return available.pick_random();

func enter(_previous_state: State, _params: Array):
	dir = get_patrol_dir();

func exit(_new_state: State):
	pass;

func update(_delta):
	pass;

func physics_update(delta):
	if character.is_on_wall():
		dir = get_patrol_dir();
	
	timer -= delta;
	if timer <= 0:
		timer = 1;
		if randf_range(0, 100) < turn_chance:
			dir = get_patrol_dir();
	
	var move_vel = dir * move_speed;
	if move_vel.length() > 0:
		if look_at_movement_dir:
			character.look_at(global_position - move_vel);
		if character.animation_player:
			character.animation_player.play("walk");
	else:
		if character.animation_player:
			character.animation_player.play("idle");
	character.velocity.x = move_vel.x;
	character.velocity.z = move_vel.z;
	
	if state_machine.has_state("Chase"):
		character.check_sights();
