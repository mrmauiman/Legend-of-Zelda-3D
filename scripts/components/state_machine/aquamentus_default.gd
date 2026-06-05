class_name AquamentusDefaultState extends State

@onready var melee_sight: Area3D = %MeleeSight;

@export var move_speed = 1.6;
@export var attack_frequency = 0.76;

var dir = Vector3(1, 0, 0);
var starting_pos: Vector3 = Vector3(4.8, 0, 0);

var attack_timer: float = attack_frequency;

func check_melee():
	for body in melee_sight.get_overlapping_bodies():
		if body.is_in_group("Link"):
			character.animation_player.play("melee_attack");

func _animation_finished(anim):
	if anim == "get_up":
		character.animation_player.play("walk");

func enter(_previous_state: State, _params: Array):
	if character.animation_player.current_animation == "get_up":
		character.animation_player.animation_finished.connect(_animation_finished, CONNECT_ONE_SHOT);
	else:
		character.animation_player.play("walk");

func exit(_new_state: State):
	pass;

func update(_delta):
	pass

func physics_update(delta):
	if not character.animation_player.is_playing():
		character.animation_player.play("walk");
	if character.animation_player.current_animation == "walk":
		if (dir == Vector3(1, 0, 0) and character.position.x >= 5.3) or (dir == Vector3(-1, 0, 0) and character.position.x <= 4.3):
			dir *= -1;
		
		attack_timer -= delta;
		if character.pissed:
			attack_timer -= delta;
		if attack_timer <= 0:
			attack_timer += attack_frequency;
			character.animation_player.play("ranged_attack");
		else:
			check_melee();

		character.velocity = dir * move_speed;
