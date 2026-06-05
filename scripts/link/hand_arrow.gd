extends Node3D

const ARROW_SCENE: PackedScene = preload("res://scenes/link/arrow.tscn");

@onready var link_model = get_parent().get_parent().get_parent().get_parent();

func fire():
	SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);
	if Inventory.counters.rupees == 0 or Inventory.items.arrow == Inventory.ITEM_TYPES.NONE: return;
	var location;
	var forward = link_model.global_transform.basis.z;
	var forward_place = forward * 0.8;
	location = link_model.global_position + (Vector3.UP * 0.8) + forward_place;
	var arrow = ARROW_SCENE.instantiate();
	arrow.position = location;
	arrow.direction = forward.normalized();
	arrow.frame = %ArrowSprite.frame;
	get_tree().root.add_child(arrow);
	Inventory.counters.rupees -= 1;
