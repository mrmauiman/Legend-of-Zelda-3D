extends State

@onready var path_blocker = get_node("PathBlocker")
@onready var text = get_node("%Text");

func enter(previous_state: State, _params: Array):
	if previous_state and previous_state.name == "Eat":
		character.queue_free();
	else:
		path_blocker.global_position = character.global_position;
		text.reveal = true;
		character.animation_player.play("idle");

func exit(_new_state: State):
	text.visible = false;

func update(_delta):
	pass;

func physics_update(_delta):
	pass;
