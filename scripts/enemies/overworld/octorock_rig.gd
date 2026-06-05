extends Node3D

const ROCK_SCENE: PackedScene = preload("res://scenes/enemies/overworld/octorock_rock.tscn");

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
	var rock = ROCK_SCENE.instantiate();
	rock.position = global_position + (forward * 0.4) + (Vector3.UP * 0.4);
	rock.direction = forward;
	get_tree().root.add_child(rock);
