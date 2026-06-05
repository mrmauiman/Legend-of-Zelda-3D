extends Node3D

const BEAM_SCENE: PackedScene = preload("res://scenes/link/magic_beam.tscn");

@onready var link_model = get_parent().get_parent().get_parent().get_parent();

var beam;

func fire():
	if beam: return;
	var location;
	var forward = link_model.global_transform.basis.z;
	var forward_place = forward * 0.8;
	location = link_model.global_position + (Vector3.UP * 0.8) + forward_place;
	beam = BEAM_SCENE.instantiate();
	beam.position = location;
	beam.direction = forward.normalized();
	beam.fire = Inventory.items.book_of_magic == Inventory.ITEM_TYPES.LVL1;
	get_tree().root.add_child(beam);
	SoundSystem.play("res://audio/sfx/MagicRod.wav", global_position);
