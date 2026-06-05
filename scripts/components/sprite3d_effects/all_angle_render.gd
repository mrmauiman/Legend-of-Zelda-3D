@tool
extends Node3D

@export var on: bool = false;

@export var side: Sprite3D;
@export var iso: Sprite3D;

var editor_camera;
var game_camera;

func set_visible_sprite(camera: Camera3D):
	var camera_forward: Vector3 = -camera.global_transform.basis.z.normalized();
	var angle_from_top = rad_to_deg(camera_forward.angle_to(Vector3.DOWN));
	if angle_from_top < 60 and on:
		iso.visible = true;
		side.visible = false;
	else:
		iso.visible = false;
		side.visible = true;

func _process(_delta):
	if Engine.is_editor_hint():
		if not editor_camera:
			var editor_interface = Engine.get_singleton("EditorInterface");
			var vp = editor_interface.get_editor_viewport_3d();
			editor_camera = vp.get_camera_3d();
		set_visible_sprite(editor_camera);
	else:
		set_visible_sprite(get_viewport().get_camera_3d());
