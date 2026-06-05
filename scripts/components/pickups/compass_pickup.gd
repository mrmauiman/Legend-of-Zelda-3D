class_name CompassPickup extends Pickup

func pickup(link):
	Inventory.levels[Inventory.current_level].compass = true;
	link.pickup("compass", Inventory.ITEM_TYPES.NONE);
	SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
