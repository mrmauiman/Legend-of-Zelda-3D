extends Node3D

const BOOMERANG_SCENE: PackedScene = preload("res://scenes/link/boomerang.tscn");

@onready var link_model = get_parent().get_parent().get_parent().get_parent();
@onready var link = link_model.get_parent();
@onready var wall_check: RayCast3D = link_model.get_node("WallCheck");

func throw():
	var boomerang = BOOMERANG_SCENE.instantiate();
	var forward = link_model.global_transform.basis.z;
	var forward_place = forward * 1.6;
	if wall_check.is_colliding():
		forward_place = (wall_check.get_collision_point() - link_model.global_position) - (forward * 0.3);
	boomerang.position = link_model.global_position + forward_place + (Vector3.UP * 0.8);
	boomerang.direction = forward;
	boomerang.link = link;
	get_tree().root.add_child(boomerang);
	link.boomerang_thrown = true;
