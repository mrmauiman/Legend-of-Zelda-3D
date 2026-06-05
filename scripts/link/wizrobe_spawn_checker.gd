class_name WizzrobeSpawnChecker extends Node3D

@onready var casts: Array[ShapeCast3D] = [get_node("XPlusCast"), get_node("XMinusCast"), get_node("ZPlusCast"), get_node("ZMinusCast")];
@onready var spawn_points: Node3D = get_node("SpawnPoints");
@onready var visualizer: Node3D = get_node("Visualizer");

@export var visualize: bool = false;

var valid_spawn_points = [];

func refresh_visualizer():
	for node in visualizer.get_children():
		node.visible = false;

func visualize_check(check: Area3D):
	if visualizer.has_node(str(check.name)):
		visualizer.get_node(str(check.name)).visible = true;
	else:
		var new_visual = CSGBox3D.new();
		new_visual.size = Vector3(1.4, 1.4, 1.4);
		new_visual.position = check.position;
		new_visual.name = check.name;
		visualizer.add_child(new_visual);

func _physics_process(_delta):
	valid_spawn_points = [];
	if visualize: refresh_visualizer();
	for cast in casts:
		var max_dist = (cast.to_global(cast.target_position) - global_position).length();
		if cast.is_colliding():
			var point = cast.get_collision_point(0);
			max_dist = (point - global_position).length();
		var check_count = max(floori(max_dist/1.6) - 1, 0);
		var prefix = cast.name.replace("Cast", "");
		var points = spawn_points.get_node(prefix);
		for i in range(check_count):
			if not points.has_node(prefix + str(i+1)): continue;
			var check: Area3D = points.get_node(prefix + str(i+1));
			if check and len(check.get_overlapping_bodies()) == 0:
				valid_spawn_points.push_back(check.global_position - Vector3(0, 0.8, 0));
				if visualize: visualize_check(check)
