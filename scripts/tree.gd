extends Node3D

var min_leaves_height: float = 0;
var max_front_leaves_height: float = 1.1;
var max_surrounded_leaves_height: float = 1.6;

func _ready():
	get_tree().create_timer(0.25).timeout.connect(set_tree_height);

func set_tree_height():
	var open = false;
	for raycast: RayCast3D in %RayCasts.get_children():
		if not raycast.is_colliding():
			open = true;
	var val;
	if open:
		val = randf_range(min_leaves_height, max_front_leaves_height);
		val = ceil(val * 16) / 16;
		%Model.position.y = val;
		$CollisionShape3D.position.y = val;
	else:
		val = randf_range(min_leaves_height, max_surrounded_leaves_height);
		val = ceil(val * 1.6) / 1.6;
		%Model.position.y = val;
		$CollisionShape3D.position.y = val;
	if not Engine.is_editor_hint():
		%RayCasts.queue_free();
