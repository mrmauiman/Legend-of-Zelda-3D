extends MarginContainer

@export var level: Inventory.LEVELS = Inventory.LEVELS.OVERWORLD;
@export var tiles_wide: int = 16;
@export var tiles_high: int = 8;
@export var map_scale: float = 2.0;

func _process(_delta):
	if not Inventory.link:
		return;
	visible = (Inventory.current_level == level);

func get_link_minimap_pos() -> Vector2:
	var global_vec2 = Vector2(Inventory.link.global_position.x, Inventory.link.global_position.z);
	var minimap_vec2 = (global_vec2 * map_scale) / 1.6;
	minimap_vec2 += Vector2((tiles_wide*16*map_scale)/2.0, (tiles_high*11*map_scale)/2.0);
	return minimap_vec2;

func get_screen_pos(screen) -> Vector2:
	var pos = Vector2.ZERO;
	pos.x = (screen.y * 16 * map_scale) + (8 * map_scale);
	pos.y = (screen.x * 11 * map_scale) + (5.5 * map_scale);
	return pos;
