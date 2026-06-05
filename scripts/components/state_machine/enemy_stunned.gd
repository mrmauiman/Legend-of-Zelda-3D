class_name EnemyStunnedState extends State

var stun_timer: float = 1;

func enter(_previous_state: State, params: Array):
	if len(params) == 0:
		state_machine.change_state("Patrol");
		return;
	
	if character.animation_player and character.animation_player.has_animation("stunned") and Inventory.clock_timer <= 0:
		character.animation_player.play("stunned");

	stun_timer = params[0];

func exit(_new_state: State):
	pass;

func update(delta):
	stun_timer -= delta;
	if stun_timer <= 0:
		state_machine.change_state("Patrol");

func physics_update(_delta):
	character.velocity = Vector3.ZERO;
