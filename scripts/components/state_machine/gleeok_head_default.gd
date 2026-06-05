class_name GleeokHeadDefaultState extends State

@export var move_speed: float = 3.2;
@export var attack_freq: float = 0.25;
@export var attack_cooldown: float = 1.0;
@export var attack_chance: float = 15; # Chance out of 100 the gleeok attacks every attack_freq seconds

const MAX_Z_WANDER: float = 2.4;
const MAX_Y_WANDER: float = 3.2;
const MAX_X_WANDER: float = 4.6;

var wander_goal: Vector3;
var timer: float = attack_freq;

func set_wander_goal():
	var base_pos: Vector3 = character.neck_point.global_position;
	var y_wander = (pow(randf_range(0, MAX_Y_WANDER), 2)/pow(MAX_Y_WANDER, 2)) * MAX_Y_WANDER;
	wander_goal = Vector3(
		randf_range(base_pos.x - MAX_X_WANDER, base_pos.x + MAX_X_WANDER),
		base_pos.y + y_wander,
		randf_range(base_pos.z + 0.4, base_pos.z + MAX_Z_WANDER)
	);

func should_attack() -> bool:
	return randf_range(0, 100) < attack_chance;

func enter(previous_state: State, _params: Array):
	set_wander_goal();
	if previous_state and previous_state.name == "Attack":
		timer = attack_cooldown;
	else:
		timer = attack_freq;

func exit(_new_state: State):
	pass;

func update(delta):
	timer -= delta;
	if timer <= 0:
		timer = attack_freq;
		if should_attack():
			state_machine.change_state("Attack");

func physics_update(delta):
	while global_position.distance_to(wander_goal) < 0.2:
		set_wander_goal();
	var dir = (wander_goal - global_position).normalized();
	character.velocity = character.velocity.lerp(dir * move_speed, delta * 5);
