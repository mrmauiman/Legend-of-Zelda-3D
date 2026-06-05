@tool
extends Node3D

@export var offset: Vector3 = Vector3.ZERO;

func _physics_process(_delta):
	global_position = get_parent().global_position + offset;