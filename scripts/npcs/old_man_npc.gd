extends Node3D

@export var location_id: String;
@export var item_1_heart_requirement: int = 1;
@export var item_2_heart_requirement: int = 1;

@export_multiline var text: String;
@export_multiline var scroll_text: String;

const ITEM_PICKUP_SCENE = preload("res://scenes/pickups/item_pickup.tscn");

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer");

var item_1_pickup = true;
var item_2_pickup = true;

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.reveal = true;

func _create_item_1():
	item_1_pickup = ITEM_PICKUP_SCENE.instantiate();
	item_1_pickup.location_id = location_id+"/item_1";
	item_1_pickup.heart_requirement = item_1_heart_requirement;
	item_1_pickup.position = position + Vector3(0, 0, 1.6 * 1.5);
	# Need to set heart requirement
	
	get_parent().add_child(item_1_pickup);
	item_1_pickup.picked_up.connect(start_item_2_timer);

func start_item_2_timer():
	get_tree().create_timer(1.5, false).timeout.connect(_show_item_2);

func _show_item_2():
	%Text.change_text(scroll_text);
	%Text.reveal_complete.connect(_create_item_2, CONNECT_ONE_SHOT);
	%Text.reveal = true;

func _create_item_2():
	item_2_pickup = ITEM_PICKUP_SCENE.instantiate();
	item_2_pickup.location_id = location_id+"/item_2";
	item_2_pickup.heart_requirement = item_2_heart_requirement;
	item_2_pickup.position = position + Vector3(0, 0, 1.6 * 1.5);
	# Need to set heart requirement
	
	get_parent().add_child(item_2_pickup);
	item_2_pickup.picked_up.connect(die);

func _ready():
	if location_id+"/item_2" in Inventory.pickup_locations_grabbed:
		queue_free();
		return;
	
	var display_text = text;
	if location_id+"/item_1" in Inventory.pickup_locations_grabbed:
		display_text = scroll_text;
		%Text.reveal_complete.connect(_create_item_2, CONNECT_ONE_SHOT);
	else:
		%Text.reveal_complete.connect(_create_item_1, CONNECT_ONE_SHOT);
	
	%Text.change_text(display_text);
	animation_player.animation_finished.connect(_animation_finished);


func _animation_finished(_anim):
	queue_free()

func die():
	animation_player.play("die");
