class_name TriforcePiecePickup extends Pickup

func pickup(link):
	Inventory.levels[Inventory.current_level].triforce_piece = true;
	link.pickup("triforce_piece", Inventory.ITEM_TYPES.NONE);
	Inventory.health = Inventory.get_max_health();
	SoundSystem.play_triforce_music();
	DoorAnimation.enter();
