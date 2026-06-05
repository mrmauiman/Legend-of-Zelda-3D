extends Label

@export var counter_id: String = "rupees";

func _process(_delta):
	if counter_id == "keys" and Inventory.items.magic_key > 0:
		text = "xA"
		return;

	var val = Inventory.counters[counter_id];
	if counter_id == "rupees":
		val = Inventory.display_rupees;
	text = "x" + str(val);
