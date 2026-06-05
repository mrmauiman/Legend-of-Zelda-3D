extends VisibleAnimationEnabler

func enable():
	super();
	node.emitting = true;

func disable():
	super();
	node.emitting = false;
