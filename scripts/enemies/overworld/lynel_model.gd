extends Node3D

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/overworld/zora_fireball.tscn");

var loaded = false:
	set(val):
		if val == loaded: return;
		if val:
			$Armature.process_mode = Node.PROCESS_MODE_PAUSABLE;
		else:
			$Armature.process_mode = Node.PROCESS_MODE_DISABLED;
		loaded = val;

func shoot():
	var forward = -global_transform.basis.z;
	forward.y = 0;
	forward = forward.normalized();
	var fire_ball = FIREBALL_SCENE.instantiate();
	fire_ball.position = global_position + (forward * 0.4) + (Vector3.UP * 0.4);
	fire_ball.direction = forward;
	get_tree().root.add_child(fire_ball);

func parried(by):
	get_parent().parried(by);
