extends Area3D

@export_file_path() var loadable_path: String;
@onready var loadable_scene = load(loadable_path) if loadable_path else null;

var loadable = null;

func load_room(link_pos: Vector3):
	loadable = loadable_scene.instantiate();
	loadable.link_pos = link_pos;
	get_parent().add_child(loadable);

func unload_room():
	if loadable: loadable.queue_free();

func _on_body_entered(body: Node3D):
	if body.is_in_group("Link") and loadable_scene:
		load_room(body.global_position);

func _on_body_exited(body: Node3D):
	if body.is_in_group("Link") and loadable_scene:
		unload_room();
