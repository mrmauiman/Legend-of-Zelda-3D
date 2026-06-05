@tool
extends Sprite3D

var editor_camera;
var game_camera;

@export var frame_offset: int = 0;

func set_anim_frame(camera: Camera3D):
	var total_frames: int = hframes * vframes;
	var vec_to_cam: Vector3 = camera.global_position - get_parent().global_position;
	# if vec_to_cam.length() > 100: 
	# 	frame = 0;
	# 	return;
	var dir_vec: Vector2 = Vector2(vec_to_cam.x, vec_to_cam.z).normalized();
	var cam_angle = dir_vec.angle_to(Vector2(0, 1));
	if cam_angle < 0:
		cam_angle = deg_to_rad(360) + cam_angle;
	var look_vec: Vector2 = Vector2(get_parent().global_transform.basis.z.x, get_parent().global_transform.basis.z.z);
	var look_angle = look_vec.angle_to(Vector2(0, 1)) * -1;
	if look_angle < 0:
		look_angle = deg_to_rad(360) + look_angle;
	var ratio = (look_angle + cam_angle)/deg_to_rad(360);
	frame = (frame_offset + int(round(ratio * total_frames))) % total_frames;

func _process(_delta):
	if not visible: return;
	if Engine.is_editor_hint():
		if not editor_camera:
			var editor_interface = Engine.get_singleton("EditorInterface");
			var vp = editor_interface.get_editor_viewport_3d();
			editor_camera = vp.get_camera_3d();
		set_anim_frame(editor_camera);
	else:
		set_anim_frame(get_viewport().get_camera_3d());
