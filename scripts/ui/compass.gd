extends TextureRect

var texture_width = 980;

func _process(_delta):
	var camera = get_viewport().get_camera_3d();
	if camera:
		var angle = camera.global_rotation.y;
		self.position.x = (fmod(angle, TAU)/TAU * texture_width)-660;
