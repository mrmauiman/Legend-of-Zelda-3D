extends Node3D

const POTION_PICKUP_SCENE: PackedScene = preload("res://scenes/pickups/potion_red_pickup.tscn");
const ITEM_PICKUP_SCENE: PackedScene = preload("res://scenes/pickups/item_pickup.tscn");

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer");
@onready var cave = get_parent();

var item_1 = true;
var item_2 = true;

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.reveal = true;

func _clear_items():
	if item_1:
		item_1.queue_free();
	if item_2:
		item_2.queue_free();
	die();

func _create_pickups():
	item_1 = POTION_PICKUP_SCENE.instantiate();
	item_1.location_id = cave.location_id;
	item_1.position = position + Vector3(-3.2, 0, 1.6 * 1.5);
	get_parent().add_child(item_1);
	item_1.picked_up.connect(_clear_items);
	
	item_2 = ITEM_PICKUP_SCENE.instantiate();
	item_2.location_id = cave.location_id;
	item_2.position = position + Vector3(3.2, 0, 1.6 * 1.5);
	get_parent().add_child(item_2);
	item_2.picked_up.connect(_clear_items);

func _ready():
	%Text.reveal_complete.connect(_create_pickups);
	animation_player.animation_finished.connect(_animation_finished);

func _process(_delta):
	if cave.location_id in Inventory.pickup_locations_grabbed:
		die();

func _animation_finished(_anim):
	queue_free()

func die():
	animation_player.play("die");
