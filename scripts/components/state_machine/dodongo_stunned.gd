extends State

func animation_finished(anim):
	if anim == "smoke_stunned":
		state_machine.change_state("Default");

func enter(_previous_state: State, _params: Array):
	character.animation_player.play("smoke_stunned");
	character.animation_player.animation_finished.connect(animation_finished);

func exit(_new_state: State):
	character.animation_player.animation_finished.disconnect(animation_finished);

func update(_delta):
	pass

func physics_update(_delta):
	character.velocity.x = 0;
	character.velocity.z = 0;
