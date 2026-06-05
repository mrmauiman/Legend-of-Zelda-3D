extends VisibleAnimationEnabler

@export var required_scroll: Inventory.SWORD_SCROLLS = Inventory.SWORD_SCROLLS.GREAT_SPIN_ATTACK;

func enable():
	if Inventory.sword_scrolls[required_scroll]:
		super();
		node.emitting = true;

func disable():
	super();
	node.emitting = false;
