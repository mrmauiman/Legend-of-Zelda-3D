extends Node3D

@export var throw_power: float = 4.8;

const FOOD_SCENE: PackedScene = preload("res://scenes/link/food.tscn");

@onready var link_model = get_parent().get_parent().get_parent().get_parent();
@onready var wall_check: RayCast3D = link_model.get_node("WallCheck");

func throw():
	var location;
	var velocity;
	var forward = link_model.global_transform.basis.z;
	var forward_place = forward * 0.8;
	if wall_check.is_colliding():
		forward_place = (wall_check.get_collision_point() - link_model.global_position) - (forward * 0.4);
	var input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward"))
	if input.length() > 0:
		location = link_model.global_position + (Vector3.UP * 1.6) + forward_place;
		velocity = (forward * throw_power) + (Vector3.UP * throw_power)
	else:
		location = link_model.global_position + (Vector3.UP * 0.8) + forward_place;
		velocity = Vector3.ZERO;
	var food = FOOD_SCENE.instantiate();
	food.position = location;
	food.velocity = velocity;
	food.dir = forward;
	get_tree().root.add_child(food);
