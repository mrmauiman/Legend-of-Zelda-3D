class_name SpawnChecker extends Node3D

var valid_spawns: Array[Vector3] = [];

signal spawns_calculated;
var spawns_calculated_flag = false;

var wait_frames: int = 1;

func _check_spawns():
	for check: Area3D in get_children():
		var shape: CollisionShape3D = check.get_node("CollisionShape3D");
		if not shape.disabled and len(check.get_overlapping_bodies()) == 0:
			valid_spawns.push_back(check.global_position);
		check.queue_free();

func _physics_process(_delta):
	if len(valid_spawns) > 0: return;
	if wait_frames > 0: 
		wait_frames -= 1;
		return;
	_check_spawns();
	spawns_calculated_flag = true;
	spawns_calculated.emit();
