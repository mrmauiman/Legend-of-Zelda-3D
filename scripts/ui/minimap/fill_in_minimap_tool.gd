@tool
extends MarginContainer

@export var generate: bool = false:
	set(val):
		fill();

@export var textures_path: String = "res://sprites/ui/minimap_tiles/";

func fill():
	var base = get_node("0_0");
	
	for r in range(8):
		for c in range(16):
			var texture_name = "";
			if c >= 10:
				texture_name = "00" + str(r+1) + "-0" + str(c);
			else:
				texture_name = "00" + str(r+1) + "-00" + str(c);
			texture_name += ".png";
			var node_name = str(r) + "_" + str(c);

			if not has_node(node_name):
				var new_screen: TextureRect = base.duplicate();
				new_screen.texture = load(textures_path + texture_name);
				new_screen.name = node_name;
				add_child(new_screen);
				new_screen.owner = get_tree().edited_scene_root;
