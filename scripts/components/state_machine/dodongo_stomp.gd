extends State

func animation_finished(anim):
	if anim == "stomp":
		state_machine.change_state("Default");

func enter(_previous_state: State, _params: Array):
	character.animation_player.play("stomp");
	character.animation_player.animation_finished.connect(animation_finished);

func exit(_new_state: State):
	character.animation_player.animation_finished.disconnect(animation_finished);

func physics_update(_delta):
	character.velocity.x = 0;
	character.velocity.z = 0;

func update(_delta):
	pass
