extends VisibleOnScreenEnabler3D

const LOAD_DIST: float = 20;

var camera: Camera3D;
func _process(_delta):
	if not camera:
		camera = get_viewport().get_camera_3d();
	var dist = (camera.global_position - global_position).length();
	if dist > LOAD_DIST:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED;
	else:
		get_parent().process_mode = Node.PROCESS_MODE_INHERIT;
