@tool
extends Sprite3D

var editor_camera;
var game_camera;

@export var frame_offset: int = 0;
@export var reverse: bool = false;

func set_anim_frame(camera: Camera3D):
	var total_frames: int = hframes * vframes;
	var vec_to_cam: Vector3 = camera.global_position - get_parent().global_position;
	var dir_vec: Vector2 = Vector2(vec_to_cam.x, vec_to_cam.z).normalized();
	var cam_angle = dir_vec.angle_to(Vector2(0, 1));
	if cam_angle < 0:
		cam_angle = deg_to_rad(360) + cam_angle;
	var look_vec: Vector2 = Vector2(get_parent().global_transform.basis.z.x, get_parent().global_transform.basis.z.z);
	var look_angle = look_vec.angle_to(Vector2(0, 1)) * -1;
	if look_angle < 0:
		look_angle = deg_to_rad(360) + look_angle;
	var ratio = (look_angle + cam_angle)/deg_to_rad(360);
	if reverse:
		ratio = 1.0-ratio;
	var new_frame = (frame_offset + int(round(ratio * total_frames)));
	if new_frame < 0: new_frame += total_frames;
	frame = new_frame % total_frames;

func billboard(camera):
	var vec_to_cam: Vector3 = camera.global_position;
	var local_vec: Vector3 = get_parent().to_local(vec_to_cam);
	if has_node("CSGSphere3D"): $CSGSphere3D.global_position = vec_to_cam * 0.5;
	local_vec.y = 0;
	local_vec = local_vec.normalized();
	look_at(get_parent().to_global(local_vec) + position, get_parent().global_transform.basis.y);

func _process(_delta):
	if Engine.is_editor_hint():
		if not editor_camera:
			var editor_interface = Engine.get_singleton("EditorInterface");
			var vp = editor_interface.get_editor_viewport_3d();
			editor_camera = vp.get_camera_3d();
		set_anim_frame(editor_camera);
		billboard(editor_camera);
	else:
		set_anim_frame(get_viewport().get_camera_3d());
		billboard(get_viewport().get_camera_3d());
