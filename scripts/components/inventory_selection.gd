extends Control

@onready var grid = %GridContainer;
@onready var selector = %Selector;

var focused_item;

func _ready():
	focused_item = grid.get_children()[0];
	focused_item.grab_focus();

func _process(_delta):
	var item_focused = false;
	for item: Control in grid.get_children():
		if item.has_focus():
			focused_item = item;
			selector.reparent(item, false);
			selector.visible = true;
			item_focused = true;
	if not item_focused:
		selector.visible = false;
	
	var icon = focused_item.get_node("Sprite2D");
	if not icon.visible and focused_item.name == "LetterAndPotion":
		icon = focused_item.get_node("Sprite2D2");
	if icon.visible:
		if Input.is_action_just_pressed("item_1"):
			if Inventory.item_slots.item_2 == icon.item_id:
				Inventory.item_slots.item_2 = Inventory.item_slots.item_1;
			if Inventory.item_slots.item_3 == icon.item_id:
				Inventory.item_slots.item_3 = Inventory.item_slots.item_1;
			Inventory.item_slots.item_1 = icon.item_id;
		if Input.is_action_just_pressed("item_2"):
			if Inventory.item_slots.item_1 == icon.item_id:
				Inventory.item_slots.item_1 = Inventory.item_slots.item_2;
			if Inventory.item_slots.item_3 == icon.item_id:
				Inventory.item_slots.item_3 = Inventory.item_slots.item_2;
			Inventory.item_slots.item_2 = icon.item_id;
		if Input.is_action_just_pressed("item_3"):
			if Inventory.item_slots.item_2 == icon.item_id:
				Inventory.item_slots.item_2 = Inventory.item_slots.item_3;
			if Inventory.item_slots.item_1 == icon.item_id:
				Inventory.item_slots.item_1 = Inventory.item_slots.item_3;
			Inventory.item_slots.item_3 = icon.item_id;
		
	
