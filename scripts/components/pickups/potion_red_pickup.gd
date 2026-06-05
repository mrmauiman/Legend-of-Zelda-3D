extends Pickup

@export var location_id: String = "";

func _ready():
	if location_id in Inventory.pickup_locations_grabbed:
		queue_free();
		return;
	
	super();

func pickup(link):
	Inventory.pickup_locations_grabbed.push_back(location_id);
	
	if Inventory.items.potion < Inventory.ITEM_TYPES.LVL2:
		Inventory.items.potion = Inventory.ITEM_TYPES.LVL2;
	link.pickup("potion", Inventory.ITEM_TYPES.LVL2);
	SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
