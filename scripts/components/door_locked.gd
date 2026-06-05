class_name DoorLocked extends Node3D

func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("Link"):
		if Inventory.items.magic_key == Inventory.ITEM_TYPES.LVL1 or Inventory.counters.keys > 0:
			if Inventory.items.magic_key != Inventory.ITEM_TYPES.LVL1:
				Inventory.counters.keys -= 1;
			SoundSystem.play("res://audio/sfx/door_opened.wav", global_position);
			queue_free();
