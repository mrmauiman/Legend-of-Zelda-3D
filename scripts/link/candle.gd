extends Node3D

const FIRE_SCENE: PackedScene = preload("res://scenes/link/fire.tscn");

@export var cool_down_time = 5;

@onready var link_model = get_parent().get_parent().get_parent().get_parent();

func refresh():
	Inventory.candle_available = true;

func _ready():
	Inventory.candle_available = true;

func use():
	if not Inventory.candle_available: return;
	SoundSystem.play("res://audio/sfx/Candle.wav", global_position);
	var forward = link_model.global_transform.basis.z;
	var forward_place = forward * 0.8;
	var location = link_model.global_position + (Vector3.UP * 0.8) + forward_place;
	var fire = FIRE_SCENE.instantiate();
	fire.position = location;
	fire.direction = forward.normalized();
	get_tree().root.add_child(fire);
	if Inventory.items.candle != Inventory.ITEM_TYPES.LVL2:
		Inventory.candle_available = false;
		get_tree().create_timer(cool_down_time, true, false, false).timeout.connect(refresh);
