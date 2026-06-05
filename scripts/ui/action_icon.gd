extends Sprite2D

func _process(_delta):
	if Inventory.current_context == Inventory.CONTEXT_ACTIONS.NONE:
		visible = false;
		return;
	visible = true;
	frame = Inventory.current_context - 1;
