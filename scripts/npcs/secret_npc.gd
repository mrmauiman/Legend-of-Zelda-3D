extends Node3D

const ITEM_PICKUP_SCENE: PackedScene = preload("res://scenes/pickups/item_pickup.tscn");

@onready var animation_player: AnimationPlayer;
@onready var cave = get_parent();

var pickup = true;
var location_id: String = "";

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.reveal = true;

func _create_pickup():
	pickup = ITEM_PICKUP_SCENE.instantiate();
	pickup.location_id = location_id;
	pickup.position = position + Vector3(0, 0, 1.6 * 1.5);
	get_parent().add_child(pickup);

func _ready():
	if has_node("MoblinModel"):
		animation_player = get_node("MoblinModel/AnimationPlayer");
	
	if cave.location_id in Inventory.pickup_locations_grabbed:
		queue_free();
		return;
	
	location_id = cave.location_id;
	if animation_player and animation_player.has_animation("idle"):
		animation_player.play("idle");
	%Text.reveal_complete.connect(_create_pickup);

func _on_text_trigger_body_exited(body):
	if body.is_in_group("Link") and not pickup:
		queue_free();
