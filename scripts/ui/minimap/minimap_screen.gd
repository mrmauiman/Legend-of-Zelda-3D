extends TextureRect

const PROCESS_TIME: float = 0.5;
var timer: float = 0.5;

@onready var minimap = get_parent().get_parent();

const NOT_VISITED_MODULATE_COLOR: Color = Color(0.3, 0.3, 0.3, 1);

func _process(delta):
	if not Inventory.link or Inventory.current_level != minimap.level: return;
	timer += delta;
	if timer >= PROCESS_TIME and Inventory.link.global_position.y > -5:
		var already_unlocked = name in Inventory.unlocked_minimap_screens[minimap.level];
		var has_map = Inventory.levels[minimap.level].map;
		if not already_unlocked:
			var coords = name.split("_");
			coords = Vector2(int(coords[1]) * (16 * minimap.map_scale), int(coords[0]) * (11*minimap.map_scale));

			var link_pos = minimap.get_link_minimap_pos();

			if link_pos.x > coords.x and link_pos.x < coords.x + (16 * minimap.map_scale):
				# Same Column
				if link_pos.y > coords.y and link_pos.y < coords.y + (11*minimap.map_scale):
					# Same Screen
					Inventory.unlocked_minimap_screens[minimap.level].push_back(name)
					already_unlocked = true;
		timer = 0;
		if has_map and not already_unlocked:
			modulate = NOT_VISITED_MODULATE_COLOR;
		elif already_unlocked:
			modulate = Color.WHITE;
		visible = already_unlocked or has_map;
