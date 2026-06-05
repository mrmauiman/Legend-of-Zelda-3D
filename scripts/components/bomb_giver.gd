extends Node

@export var bomb_holder: Enemy;

func _ready():
	bomb_holder.has_bomb = true;
	bomb_holder.tree_exited.connect(destroy);

func destroy():
	queue_free();

func _exit_tree():
	if bomb_holder:
		bomb_holder.has_key = false;
