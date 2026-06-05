extends Sprite2D

@export var item_id: String;

func _process(_delta):
	var item_type = Inventory.items[item_id]
	if item_type == Inventory.ITEM_TYPES.NONE:
		visible = false;
	elif item_id == "bomb" and Inventory.counters.bombs == 0:
		visible = false;
	elif item_id == "arrow" and Inventory.counters.rupees == 0:
		visible = false;
	elif item_id == "food" and Inventory.counters.food == 0:
		visible = false;
	elif item_id == "letter" and item_type != Inventory.ITEM_TYPES.LVL1:
		visible = true;
		texture = null;
	else:
		visible = true;
		var icon_data = Inventory.get_icon[item_id][item_type];
		texture = icon_data.ui_texture;
