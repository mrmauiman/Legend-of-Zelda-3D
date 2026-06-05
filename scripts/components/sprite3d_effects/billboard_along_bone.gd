@tool
extends Sprite3D

var editor_camera;


func billboard(camera):
	var vec_to_cam: Vector3 = camera.global_position;
	var local_vec: Vector3 = get_parent().to_local(vec_to_cam);
	if has_node("CSGSphere3D"): $CSGSphere3D.global_position = vec_to_cam * 0.5;
	local_vec.y = 0;
	local_vec = local_vec.normalized();
	look_at(get_parent().to_global(local_vec), get_parent().global_transform.basis.y);

func _process(_delta):
	if Engine.is_editor_hint():
		if not editor_camera:
			var editor_interface = Engine.get_singleton("EditorInterface");
			var vp = editor_interface.get_editor_viewport_3d();
			editor_camera = vp.get_camera_3d();
		if editor_camera:
			billboard(editor_camera);
	else:
		var game_cam = get_viewport().get_camera_3d();
		if game_cam:
			billboard(game_cam);
