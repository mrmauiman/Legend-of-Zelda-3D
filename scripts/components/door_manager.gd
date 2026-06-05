extends Node3D

func _ready():
	if EnemyTracker.dungeons[get_parent().level].has("doors"):
		load_doors();
	else:
		EnemyTracker.dungeons[get_parent().level].doors = [];
		for node in get_children():
			if node is DoorLocked or node is DungeonBombCover:
				EnemyTracker.dungeons[get_parent().level].doors.push_back(node.name);
				node.tree_exited.connect(_update_tracker);

func load_doors():
	for node in get_children():
		if node is DoorLocked or node is DungeonBombCover:
			if not node.name in EnemyTracker.dungeons[get_parent().level].doors:
				node.queue_free();
			else:
				node.tree_exited.connect(_update_tracker);

func _update_tracker():
	for door in EnemyTracker.dungeons[get_parent().level].doors:
		if not has_node(str(door)):
			EnemyTracker.dungeons[get_parent().level].doors.erase(door);

func _exit_tree():
	_update_tracker();
