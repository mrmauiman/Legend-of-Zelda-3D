extends Sprite2D

@export var id: String = "item_1";
@export var is_sword: bool = false;

func _process(_delta):
	var item = Inventory.item_slots[id];
	
	if is_sword:
		item = "sword";
	
	if item == "":
		visible = false;
		return;
	
	var item_type: Inventory.ITEM_TYPES = Inventory.items[item];
	
	if item == "letter" and item_type != Inventory.ITEM_TYPES.LVL1:
		item = "potion";
		item_type = Inventory.items[item];
	
	if item_type == Inventory.ITEM_TYPES.NONE:
		visible = false;
	elif item == "bomb" and Inventory.counters.bombs == 0:
		visible = false;
	elif item == "food" and Inventory.counters.food == 0:
		visible = false;
	else:
		visible = true;
		var icon_data = Inventory.get_icon[item][item_type];
		var is_candle_no_flame: bool = (item == "candle") and not Inventory.candle_available;
		var new_texture = icon_data.ui_texture;
		if is_candle_no_flame:
			new_texture = icon_data.ui_texture_no_flame;
		if texture.get_rid() != new_texture.get_rid():
			texture = new_texture;
		if item == "bow":
			offset = Vector2(-20, 0);
		elif is_sword:
			offset = Vector2(9, 13);
		else:
			offset = Vector2.ZERO;
	
