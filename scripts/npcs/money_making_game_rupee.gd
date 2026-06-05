extends Area3D

var count = 0;
signal picked_up;

func pickup(link):
	link.pickup("rupees", Inventory.ITEM_TYPES.NONE, count);
	SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
	Inventory.counters.rupees = clampi(Inventory.counters.rupees + count, 0, Inventory.counter_maxes.rupees);
	picked_up.emit();
	queue_free();

func _on_body_entered(body: Node3D):
	if body.is_in_group("Link"):
		pickup(body);
