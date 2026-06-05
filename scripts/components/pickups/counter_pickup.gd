class_name CounterPickup extends Pickup

@export var pickup_id: String = "";
@export var count: int = 1;
@export var is_cave: bool = false;

func pickup(link):
	Inventory.add_to_counter(pickup_id, count);
	if pickup_id == "rupees" and count != 1 and count != 5:
		link.pickup(pickup_id, Inventory.ITEM_TYPES.NONE, count);
		SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
	elif pickup_id == "heart_containers":
		Inventory.heal(1);
		if not is_cave:
			Inventory.levels[Inventory.current_level].heart_container = true;
		link.pickup(pickup_id, Inventory.ITEM_TYPES.NONE);
		SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
	elif pickup_id == "keys":
		link.pickup(pickup_id, Inventory.ITEM_TYPES.NONE);
		SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
	else:
		SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
