extends Node3D

var lit: bool = false;

@onready var link_checker: Area3D = get_node("Linkchecker");
@onready var link_checker_shape: CollisionShape3D = link_checker.get_node("CollisionShape3D");

func _ready():
	call_deferred("modify_decendent_dungeon_meshes", get_node("Pieces"), black_out_dungeon_mesh);
	link_checker_shape.shape = link_checker_shape.shape.duplicate();
	link_checker_shape.shape.size.z = 4.8;
	if not link_checker.is_connected("body_entered", _on_linkchecker_body_entered):
		link_checker.body_entered.connect(_on_linkchecker_body_entered);

func _on_linkchecker_body_entered(body):
	if body.is_in_group("Link") and not lit:
		link_checker.get_node("CollisionShape3D").shape.size.z = 9.6;
		body.hold_triforce();
		lit = true;
		modify_decendent_dungeon_meshes(get_node("Pieces"), light_dungeon_mesh);

func light_dungeon_mesh(mesh: DungeonMesh):
	mesh.light_up();

func black_out_dungeon_mesh(mesh: DungeonMesh):
	mesh.black_out();

func modify_decendent_dungeon_meshes(node: Node, callback: Callable):
	for child in node.get_children():
		if child is DungeonMesh:
			callback.call(child);
		
		if child is OmniLight3D:
			if callback == light_dungeon_mesh:
				child.light_energy = 1;
			else:
				child.light_energy = 0;
		
		if child.get_child_count() > 0:
			modify_decendent_dungeon_meshes(child, callback);
