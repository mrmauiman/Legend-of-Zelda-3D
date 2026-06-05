extends Area3D

@onready var sprite: Sprite3D = $Sprite;

enum PICKUP_TYPE {ITEM, COUNTER, HEART, FAIRY, CLOCK};

@export var type: PICKUP_TYPE = PICKUP_TYPE.ITEM;
@export var pickup_id: String;
@export var item_type: Inventory.ITEM_TYPES;
@export var count: int = 0;
@export var heart_requirement: int = 5;

signal picked_up;

func _on_body_entered(body):
	if body.is_in_group("Link") and Inventory.counters.heart_containers >= heart_requirement:
		match type:
			PICKUP_TYPE.ITEM:
				if Inventory.items[pickup_id] < item_type:
					Inventory.items[pickup_id] = item_type;
				body.pickup(pickup_id, item_type);
			PICKUP_TYPE.COUNTER:
				Inventory.counters[pickup_id] += count;
				if pickup_id == "rupees" and count != 1 and count != 5:
					body.pickup(pickup_id, Inventory.ITEM_TYPES.NONE, count);
			PICKUP_TYPE.HEART:
				Inventory.take_damage(-2);
			PICKUP_TYPE.FAIRY:
				Inventory.take_damage(-Inventory.get_max_health());
			PICKUP_TYPE.CLOCK:
				pass
		picked_up.emit();
		queue_free();
