extends Node

@export var compass_holder: Enemy;

func _ready():
	compass_holder.has_compass = true;
	compass_holder.tree_exited.connect(destroy);

func destroy():
	queue_free();

func _exit_tree():
	if compass_holder:
		compass_holder.has_compass = false;
