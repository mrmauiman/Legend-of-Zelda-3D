@tool
extends Sprite3D

var editor_camera;

const PHI = (1.0 + sqrt(5.0))/2.0;
const PHI_REC = (sqrt(5.0)-1)/2.0;
const K = PHI_REC/sqrt(3.0);
const M = PHI/sqrt(3.0);
var face_vectors = [
	Vector3(0, 0, 1),
	Vector3(0, 0, 1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(54)), deg_to_rad(63.435)),
	Vector3(0, 0, 1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(-54)), deg_to_rad(-63.435)),
	Vector3(0, 0, 1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(-18)), deg_to_rad(63.435)),
	Vector3(0, 0, 1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(18)), deg_to_rad(-63.435)),
	Vector3(0, 0, 1).rotated(Vector3.RIGHT, deg_to_rad(63.435)),
	Vector3(0, 0, -1).rotated(Vector3.RIGHT, deg_to_rad(63.435)),
	Vector3(0, 0, -1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(18)), deg_to_rad(-63.435)),
	Vector3(0, 0, -1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(-18)), deg_to_rad(63.435)),
	Vector3(0, 0, -1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(-54)), deg_to_rad(-63.435)),
	Vector3(0, 0, -1).rotated(Vector3(0, 1, 0).rotated(Vector3.BACK, deg_to_rad(54)), deg_to_rad(63.435)),
	Vector3(0, 0, -1),
];

func set_anim_frame(camera: Camera3D):
	var vec_to_cam: Vector3 = camera.global_position - global_position;
	var smallest_angle = deg_to_rad(360);
	var index = -1;
	for i in range(len(face_vectors)):
		var angle = vec_to_cam.angle_to(get_parent().to_global(face_vectors[i]))
		if angle < smallest_angle:
			smallest_angle = angle;
			index = i;
	frame = index;
	look_at(camera.global_position, get_parent().to_global(Vector3.UP));
	
	#var dir_vec: Vector2 = Vector2(vec_to_cam.x, vec_to_cam.z).normalized();
	#var cam_angle = dir_vec.angle_to(Vector2(0, 1));
	#if cam_angle < 0:
		#cam_angle = deg_to_rad(360) + cam_angle;
	#var look_vec: Vector2 = Vector2(get_parent().global_transform.basis.z.x, get_parent().global_transform.basis.z.z);
	#var look_angle = look_vec.angle_to(Vector2(0, 1)) * -1;
	#if look_angle < 0:
		#look_angle = deg_to_rad(360) + look_angle;
	#var ratio = (look_angle + cam_angle)/deg_to_rad(360);
	#frame = (int(round(ratio * total_frames))) % total_frames;

func _process(_delta):
	if Engine.is_editor_hint():
		if not editor_camera:
			var editor_interface = Engine.get_singleton("EditorInterface");
			var vp = editor_interface.get_editor_viewport_3d();
			editor_camera = vp.get_camera_3d();
		set_anim_frame(editor_camera);
	else:
		set_anim_frame(get_viewport().get_camera_3d());
