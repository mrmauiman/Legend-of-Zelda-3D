extends Pickup

func pickup(link):
	link.pickup("triforce_of_power", Inventory.ITEM_TYPES.NONE);
	SoundSystem.play_triforce_music();
