extends State

var link: CharacterBody3D;

func enter(_previous_state: State, params: Array):
	if not params[0] or not params[0].is_in_group("Link"):
		state_machine.change_state("Patrol");
	
	link = params[0];
	character.animation_player.play("eat");

func exit(_new_state: State):
	link = null;

func update(_delta):
	if character.animation_player.current_animation_position > 1.5:
		if Inventory.items.shield == Inventory.ITEM_TYPES.LVL2:
			Inventory.items.shield = Inventory.ITEM_TYPES.LVL1;
		state_machine.change_state("Patrol");

func physics_update(_delta):
	if not link: return;
	link.global_position = global_position;


func _on_eat_box_body_entered(body):
	if body.is_in_group("Link") and body.state != body.STATES.HURT:
		state_machine.change_state("Eating", body);
