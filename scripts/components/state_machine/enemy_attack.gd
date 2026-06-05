class_name EnemyAttackState extends State

func animation_finished(_anim):
	state_machine.change_state("Chase");

func enter(_previous_state: State, _params: Array):
	character.animation_player.play("attack");
	character.animation_player.animation_finished.connect(animation_finished);

func exit(_new_state: State):
	character.animation_player.animation_finished.disconnect(animation_finished);

func update(_delta):
	pass;

func physics_update(_delta):
	character.velocity = Vector3(0, character.velocity.y, 0);
