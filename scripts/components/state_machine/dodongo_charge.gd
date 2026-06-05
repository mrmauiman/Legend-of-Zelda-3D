extends State

func enter(_previous_state: State, _params: Array):
	character.velocity *= 2;
	character.animation_player.play("charge");

func exit(_new_state: State):
	pass

func update(_delta):
	pass

func physics_update(_delta):
	if character.is_on_wall():
		state_machine.change_state("Default");
