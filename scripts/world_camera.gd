extends Camera3D

@onready var other_cam = get_parent().get_parent().get_parent().get_node("%Camera3D");

func _process(_delta):
	global_transform = other_cam.global_transform;
