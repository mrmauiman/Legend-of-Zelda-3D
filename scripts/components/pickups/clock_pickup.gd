extends Pickup

const CLOCK_FREEZE_TIME: float = 10.0;

func pickup(_link):
	Inventory.clock_timer = CLOCK_FREEZE_TIME;
	SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
