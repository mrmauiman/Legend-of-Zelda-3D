class_name InvisibleAnimationEnabler extends AnimationEnabler

@onready var node: Node3D = get_parent();

func enable():
	node.visible = false;

func disable():
	node.visible = true;
