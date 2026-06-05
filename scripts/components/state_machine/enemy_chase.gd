class_name EnemyChaseState extends State

var link: CharacterBody3D;

@export var move_speed: float = 4.8;
@export var attack_chance: float = 25;
@export var attack_frequency: float = 0.1;

var chasing: bool = true;
var timer: float = attack_frequency;

func enter(_previous_state: State, params: Array):
	if len(params) == 0:
		if not link:
			state_machine.change_state("Patrol");
			return;
	else:
		link = params[0];
	
	chasing = true;

func exit(new_state: State):
	if new_state.name == "Patrol":
		link = null;

func update(_delta):
	pass;

func physics_update(delta):
	var link_vec = link.global_position - global_position;
	var dir_vec = link_vec;
	dir_vec.y = 0;
	dir_vec = dir_vec.normalized();
	character.look_at(global_position - dir_vec);
	if (chasing and link_vec.length() > 1.6) or ((not chasing) and link_vec.length() > 1.9):
		chasing = true;
		character.animation_player.play("walk");
		character.velocity.x = dir_vec.x * move_speed;
		character.velocity.z = dir_vec.z * move_speed;
		timer = attack_frequency;
	else:
		chasing = false;
		character.animation_player.play("idle");
		character.velocity.x = 0;
		character.velocity.z = 0;
		timer -= delta;
		if timer <= 0:
			if randf_range(1, 100) <= attack_chance:
				state_machine.change_state("Attack");
				return;
			timer = attack_frequency;

	character.check_sights();
