class_name VisibleAnimationEnabler extends AnimationEnabler

@onready var node: Node3D = get_parent();

func enable():
	node.visible = true;

func disable():
	node.visible = false;
