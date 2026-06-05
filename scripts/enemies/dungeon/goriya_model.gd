extends Node3D

const BOOMERANG_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/goriya_boomerang.tscn");

@onready var goriya = get_parent();
@export var has_boomerang = true;
@export var blue = false;

var has_key: bool = false;
var has_compass: bool = false;
var has_bomb: bool = false;
var has_item: bool = false;

func _process(_delta):
	%Boomerang.visible = has_boomerang and not get_parent().boomerang_thrown;
	%HipKey.visible = has_key;
	%HipCompass.visible = has_compass;
	%HipBomb.visible = has_bomb;
	%HipItem.visible = has_item;

func throw():
	var dir = goriya.global_transform.basis.z;
	dir.y = 0;
	dir = dir.normalized();
	var boomerang = BOOMERANG_SCENE.instantiate();
	boomerang.blue = blue;
	boomerang.direction = dir
	boomerang.goriya = goriya;
	boomerang.position = goriya.global_position + (dir * 0.8) + Vector3(0, 0.8, 0);
	get_tree().root.add_child(boomerang);
