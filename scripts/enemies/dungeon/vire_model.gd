extends Node3D

var has_key: bool = false;
var has_compass: bool = false;
var has_bomb: bool = false;
var has_item: bool = false;

func _process(_delta):
	%HipKey.visible = has_key;
	%HipCompass.visible = has_compass;
	%HipBomb.visible = has_bomb;
	%HipItem.visible = has_item;
