extends Node3D

var loaded = false;

const LOAD_DIST = 3 * 25.6;

const BOUNDING_BOX: AABB = AABB(Vector3(-12.8, 0, -8.8), Vector3(25.6, 32, 17.6));

var camera;

var respawn_enemies: bool = false;

var on_screen_notifier: VisibleOnScreenNotifier3D;

func _ready():
	for node in get_children():
		node.process_mode = Node.PROCESS_MODE_DISABLED;
		node.visible = false;
	
	on_screen_notifier = VisibleOnScreenNotifier3D.new();
	on_screen_notifier.aabb = BOUNDING_BOX;
	on_screen_notifier.position = position;
	get_parent().add_child.call_deferred(on_screen_notifier);
	

func _process(_delta):
	if not camera:
		camera = get_viewport().get_camera_3d();
	
	var my_pos = Vector2(global_position.x, global_position.z);
	var camera_pos = Vector2(camera.global_position.x, camera.global_position.z);
	var on_screen = on_screen_notifier.is_on_screen();
	var dist = (my_pos - camera_pos).length();
	var in_load_dist = dist <= LOAD_DIST;
	if on_screen_notifier.get_path():
		pass
	if in_load_dist and on_screen:
		if not loaded:
			loaded = true;
			for node in get_children():
				node.process_mode = Node.PROCESS_MODE_INHERIT;
				node.visible = true;
	else:
		if loaded:
			loaded = false;
			for node in get_children():
				node.process_mode = Node.PROCESS_MODE_DISABLED;
				node.visible = false;
