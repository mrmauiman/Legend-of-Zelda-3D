extends Node3D

var lit: bool = false;

@onready var link_checker: Area3D = get_node("Linkchecker");

func _ready():
	call_deferred("modify_decendent_dungeon_meshes", get_node("Pieces"), black_out_dungeon_mesh);
	if not link_checker.is_connected("area_entered", _on_linkchecker_area_entered):
		link_checker.area_entered.connect(_on_linkchecker_area_entered);

func _on_linkchecker_area_entered(area):
	if area is HitBox and area.is_in_group("Fire") and not lit:
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
