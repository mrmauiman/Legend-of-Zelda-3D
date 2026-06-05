extends VisibleAnimationEnabler

func enable():
	super();
	node.emitting = true;
	node.length = 15;

func disable():
	super();
	node.emitting = false;
	node.length = 1;
