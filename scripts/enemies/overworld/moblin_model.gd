extends Node3D

@export var is_npc = false;
@export var is_blue = false;

var loaded = false:
	set(val):
		if val == loaded: return;
		if val:
			$Armature.process_mode = Node.PROCESS_MODE_PAUSABLE;
		else:
			$Armature.process_mode = Node.PROCESS_MODE_DISABLED;
		loaded = val;

func _ready():
	%SpearSlot.visible = not is_npc;

const SPEAR_SCENE: PackedScene = preload("res://scenes/enemies/overworld/moblin_spear.tscn");
const BLUE_SPEAR_SCENE: PackedScene = preload("res://scenes/enemies/overworld/moblin_spear_blue.tscn");

func throw():
	var forward = global_transform.basis.z;
	forward.y = 0;
	forward = forward.normalized();
	var spear;
	if is_blue:
		spear = BLUE_SPEAR_SCENE.instantiate();
	else:
		spear = SPEAR_SCENE.instantiate();
	spear.position = global_position + (forward * 0.4) + (Vector3.UP * 0.4);
	spear.direction = forward;
	get_tree().root.add_child(spear);

func blocked(by):
	get_parent().blocked(by);

func parried(by):
	get_parent().parried(by);
