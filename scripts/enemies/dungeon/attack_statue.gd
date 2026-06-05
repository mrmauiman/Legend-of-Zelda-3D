extends Node3D

@onready var link = Inventory.link;

@export var fire_frequency_min: float = 3.5;
@export var fire_frequency_max: float = 10;

var timer = 0;

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/overworld/zora_fireball.tscn");

func reset_timer():
	timer = randf_range(fire_frequency_min, fire_frequency_max);

func fire():
	# Fire Projectile
	var fireball = FIREBALL_SCENE.instantiate();
	fireball.position = global_position + (Vector3.UP * 0.8);
	fireball.direction = (link.global_position - global_position).normalized();
	fireball.objects_to_ignore.push_back($StaticBody3D);
	get_tree().root.add_child(fireball);

	reset_timer();

func _ready():
	reset_timer();

func _process(delta):
	timer -= delta;
	if timer <= 0:
		fire();
