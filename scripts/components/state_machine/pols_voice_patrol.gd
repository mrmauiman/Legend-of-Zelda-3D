extends State

var dir: Vector3 = Vector3.ZERO;
var jump_timer: float = 0;

@export var turn_speed: float = 20; # max angle in degrees the vire turns every jump
@export var move_speed: float = 6.4;
@export var jump_velocity: Vector3 = Vector3(0, 8, 0);
@export var jump_wait: float = 0.1; # time in seconds between jumps
@export var jump_chance: float = 25; # Chance out of 100 the pols voice jumps every jump_wait seconds

func set_random_dir():
	while(true):
		dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1));
		if dir.length() > 0:
			dir = dir.normalized();
			break;

func adjust_dir():
	dir = dir.rotated(Vector3.UP, deg_to_rad(randf_range(-turn_speed, turn_speed)));

func animation_finished(anim):
	if anim == "prepare_jump" and state_machine.current_state_is("Patrol"):
		jump();

func start_jump():
	adjust_dir();
	character.animation_player.play("prepare_jump");

func jump():
	character.velocity = (dir * move_speed) + jump_velocity;
	character.look_at(character.global_position + dir);
	jump_timer = jump_wait;
	character.animation_player.play("jump");

func enter(_previous_state: State, _params: Array):
	set_random_dir();
	character.animation_player.animation_finished.connect(animation_finished);

func exit(_new_state: State):
	character.animation_player.animation_finished.disconnect(animation_finished);

func update(_delta):
	pass;

func physics_update(delta):
	if character.is_on_floor() and character.animation_player.current_animation != "prepare_jump":
		character.animation_player.play("idle");
		character.velocity.x = 0;
		character.velocity.z = 0;
		jump_timer -= delta;
		if jump_timer <= 0:
			if randf_range(0, 100) < jump_chance:
				start_jump();
			jump_timer = jump_wait;
	
	if character.is_on_wall():
		var wall_norm = character.get_wall_normal();
		if wall_norm.angle_to(-dir) < deg_to_rad(45):
			dir = dir.bounce(wall_norm);
