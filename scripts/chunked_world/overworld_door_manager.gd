extends Node3D

func _ready():
	if EnemyTracker.overworld_doors:
		load_doors();
	else:
		EnemyTracker.overworld_doors = [];
		for node in get_children():
			if node is BombableWall or node is BurnableTree:
				EnemyTracker.overworld_doors.push_back(node.name);
				node.tree_exited.connect(_update_tracker);

func load_doors():
	for node in get_children():
		if node is BombableWall or node is BurnableTree:
			if not node.name in EnemyTracker.overworld_doors:
				node.queue_free();
			else:
				node.tree_exited.connect(_update_tracker);

func _update_tracker():
	for door in EnemyTracker.overworld_doors:
		if not has_node(str(door)):
			EnemyTracker.overworld_doors.erase(door);

func _exit_tree():
	_update_tracker();
