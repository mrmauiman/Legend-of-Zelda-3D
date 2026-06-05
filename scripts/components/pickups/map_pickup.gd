class_name MapPickup extends Pickup

func pickup(link):
	Inventory.levels[Inventory.current_level].map = true;
	link.pickup("map", Inventory.ITEM_TYPES.NONE);
	SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
