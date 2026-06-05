extends State

@export var flip_look: bool = false;
@export var bite_size: float = 1;

var food;

func enter(_previous_state: State, params: Array):
	if not params[0]:
		state_machine.change_state("Patrol");
	
	food = params[0];

func exit(_new_state: State):
	pass;

func update(_delta):
	pass;

func physics_update(delta):
	if not food:
		state_machine.change_state("Patrol");
		return;
	var dist_to_food = character.global_position.distance_to(food.global_position);
	var dir = food.global_position - character.global_position;
	dir.y = 0;
	dir = dir.normalized();
	if dist_to_food < 1:
		character.velocity.x = 0;
		character.velocity.z = 0;
		character.animation_player.play("eat");
		food.take_bite(delta * bite_size);
	else:
		character.animation_player.play("walk");
		var vel_y = character.velocity.y;
		character.velocity = dir * 4.8;
		character.velocity.y = vel_y;
	var mul = 1 if flip_look else -1;
	character.look_at(character.global_position + (dir * mul));
