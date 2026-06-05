@tool
extends Node3D

const WIDTH: int = 16;
const HEIGHT: int = 8;

@export var generate: bool = false:
	set(val):
		generate_nodes();

func generate_nodes():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var node = Node3D.new();
			node.name = "Screen_" + str(y) + "_" + str(x);
			var signed_y = ((7 - y) - 4);
			var signed_x = x - 8;
			node.position.z = (signed_y * 17.6) + 8.8;
			node.position.x = (signed_x * 25.6) + 12.8;
			add_child(node);
			node.owner = get_tree().edited_scene_root;
