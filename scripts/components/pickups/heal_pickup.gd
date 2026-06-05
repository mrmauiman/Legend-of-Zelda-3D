class_name HealPickup extends Pickup

@export var amount: int = 1;

func pickup(_link):
	Inventory.heal(amount);
	SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
