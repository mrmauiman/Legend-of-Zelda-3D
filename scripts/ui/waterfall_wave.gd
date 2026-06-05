extends Sprite2D

@onready var onscreen_notifier: VisibleOnScreenNotifier2D = get_node("VisibleOnScreenNotifier2D");

@export var on: bool = false;
@export var gravity: float = 100;

func _physics_process(delta):
	visible = on;
	if on:
		position.y += gravity * delta;
		if not onscreen_notifier.is_on_screen():
			queue_free();
