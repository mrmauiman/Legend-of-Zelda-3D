class_name GoriyaThrowState extends State

func _animation_finished(_anim):
	state_machine.change_state("Patrol");

func enter(_previous_state: State, _params: Array):
	character.animation_player.play("throw");
	character.animation_player.animation_finished.connect(_animation_finished, CONNECT_ONE_SHOT);

func exit(_new_state: State):
	pass;

func update(_delta):
	pass;

func physics_update(_delta):
	character.velocity.x = 0;
	character.velocity.z = 0;
