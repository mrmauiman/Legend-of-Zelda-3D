extends Node3D


func _on_hit_box_parried(_by):
	get_parent().parried();
