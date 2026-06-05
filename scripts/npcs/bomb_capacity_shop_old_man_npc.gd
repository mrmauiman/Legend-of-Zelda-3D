extends Node3D

@export var location_id: String;

@export_multiline var text: String;

const shop_scene = preload("res://scenes/pickups/shop_pickup.tscn");

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer");

var shop_pickup = true;

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.reveal = true;

func _create_sword():
	shop_pickup = shop_scene.instantiate();
	shop_pickup.position = get_parent().to_local(global_position + Vector3(0, 0, 1.6 * 1.5));
	shop_pickup.id = location_id;
	shop_pickup.price = 100;
	shop_pickup.multi_purchase = false;
	get_parent().add_child(shop_pickup);

func _ready():
	%Text.change_text(text);
	%Text.reveal_complete.connect(_create_sword);
	animation_player.animation_finished.connect(_animation_finished);

func _process(_delta):
	if not shop_pickup:
		die();

func _animation_finished(_anim):
	queue_free()

func die():
	animation_player.play("die");
