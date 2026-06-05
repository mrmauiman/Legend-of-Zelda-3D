extends ItemPickup

@export var heart_requirement: float = 5;

func can_pickup(_link):
	return Inventory.get_max_health() >= Inventory.hearts_to_health(heart_requirement);
