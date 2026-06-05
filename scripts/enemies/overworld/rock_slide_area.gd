extends Area3D

const SPAWN_FREQ: float = 0.5;

var link_inside = false;
var timer = SPAWN_FREQ;

@export var spawn_height: float = 16;
@export var spawn_chance: float = 35;

const ROCK_SCENE: PackedScene = preload("res://scenes/enemies/overworld/rock.tscn");


func spawn_rock():
	var rock = ROCK_SCENE.instantiate();
	rock.position = global_position + Vector3(randf_range(-12.8, 12.8), spawn_height, randf_range(-8.8, 8.8));
	get_tree().root.add_child(rock);

func _process(delta):
	if not link_inside: return;
	timer -= delta;
	if timer <= 0:
		spawn_rock();
		timer = SPAWN_FREQ;

func _on_body_entered(body):
	if body.is_in_group("Link"):
		link_inside = true;


func _on_body_exited(body):
	if body.is_in_group("Link"):
		link_inside = false;
