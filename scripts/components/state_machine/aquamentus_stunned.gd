extends State

var timer = 0;

func _animation_finished(_anim):
	character.animation_player.play("stunned");

func enter(_previous_state: State, params: Array):
	if len(params) == 0:
		state_machine.change_state("Default");
	
	timer = params[0];
	character.animation_player.animation_finished.connect(_animation_finished, CONNECT_ONE_SHOT);

func exit(_new_state: State):
	character.animation_player.play("get_up");

func update(delta):
	if character.animation_player.current_animation != "stun_start":
		timer -= delta;
		if timer <= 0:
			state_machine.change_state("Default");

func physics_update(_delta):
	pass;
