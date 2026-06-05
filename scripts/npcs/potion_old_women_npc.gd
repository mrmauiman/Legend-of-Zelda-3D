extends Node3D

var item_1_pickup;
var item_2_pickup;

const SHOP_PICKUP_SCENE: PackedScene = preload("res://scenes/pickups/shop_pickup.tscn");

@export_multiline var text: String = "";

func clear_medicine():
	if item_1_pickup:
		item_1_pickup.queue_free();
	if item_2_pickup:
		item_2_pickup.queue_free();

func spawn_medicine():
	item_1_pickup = SHOP_PICKUP_SCENE.instantiate();
	item_1_pickup.price = 40;
	item_1_pickup.id = "potion_shop/item_1";
	item_1_pickup.position = Vector3(-3.2, 0, 2.4);
	add_child(item_1_pickup);
	
	item_2_pickup = SHOP_PICKUP_SCENE.instantiate();
	item_2_pickup.price = 68;
	item_2_pickup.id = "potion_shop/item_2";
	item_2_pickup.position = Vector3(3.2, 0, 2.4);
	add_child(item_2_pickup);

func saw_letter():
	Inventory.items.letter = Inventory.ITEM_TYPES.LVL2;
	%Text.change_text(text);
	%Text.reveal = true;
	%Text.reveal_complete.connect(spawn_medicine, CONNECT_ONE_SHOT);

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		if Inventory.items.letter == Inventory.ITEM_TYPES.LVL2:
			%Text.change_text(text);
			%Text.reveal = true;
			%Text.reveal_complete.connect(spawn_medicine, CONNECT_ONE_SHOT);
		else:
			body.show_letter.connect(saw_letter);

func _on_text_trigger_body_exited(body):
	if body.is_in_group("Link"):
		clear_medicine();
		if body.show_letter.is_connected(saw_letter):
			body.show_letter.disconnect(saw_letter);
