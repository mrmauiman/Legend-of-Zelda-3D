extends Node3D

@export_multiline var text: String;

const pickup_scene = preload("res://scenes/pickups/item_pickup.tscn");

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer");

const LOCATION_ID = "cave/letter_cave";

var pickup = true;

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.reveal = true;

func _create_pickup():
	pickup = pickup_scene.instantiate();
	pickup.location_id = LOCATION_ID;
	pickup.position = position + Vector3(0, 0, 1.6 * 1.5);
	get_parent().add_child(pickup);

func _ready():
	if LOCATION_ID in Inventory.pickup_locations_grabbed:
		queue_free();
		return;
	%Text.change_text(text);
	%Text.reveal_complete.connect(_create_pickup);
	animation_player.animation_finished.connect(_animation_finished);

func _process(_delta):
	if not pickup:
		die();

func _animation_finished(_anim):
	queue_free()

func die():
	animation_player.play("die");

func _exit_tree():
	if pickup and typeof(pickup) != TYPE_BOOL:
		pickup.queue_free();
