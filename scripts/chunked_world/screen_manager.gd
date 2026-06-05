@tool
extends Node3D

@onready var link = get_parent().get_node("Link");

@export var screen_to_load: String = "";
@export var load_it: bool = false:
	set(val):
		load_screen(screen_to_load);

const NUM_SCREENS_X: int = 16;
const NUM_SCREENS_Z: int = 8;

const SCREEN_WIDTH: float = 25.6;
const SCREEN_HEIGHT: float = 17.6;

const SCREEN_SCENE_FOLDER_PATH: String = "res://scenes/chunked_worlds/overworld/screens/";

const RESPAWN_UNIQUE_SCREEN_COUNT: int = 8;

var screen: Node3D;

var screens_visited: Array[String] = [];

# Converts a screen name into it's world position
func screen_name_to_global_position(screen_name: String) -> Vector3:
	# Extract coordinates from screen name
	var screen_data = screen_name.split("_")
	var coords = Vector2(int(screen_data[2]), int(screen_data[1]));
	# Covert coordinates into world space
	coords.y = (NUM_SCREENS_Z-1) - coords.y;
	var pos = Vector3(coords.x * SCREEN_WIDTH, 0, coords.y * SCREEN_HEIGHT);
	pos -= Vector3(SCREEN_WIDTH * (NUM_SCREENS_X/2.0), 0, SCREEN_HEIGHT * (NUM_SCREENS_Z/2.0));
	pos += Vector3(SCREEN_WIDTH/2.0, 0, SCREEN_HEIGHT/2.0);
	return pos;

# Converts links position into screen coordinates
func get_current_screen() -> Vector2i:
	var link_pos = Vector2(link.global_position.x, link.global_position.z);
	link_pos += Vector2(SCREEN_WIDTH * (NUM_SCREENS_X/2.0), SCREEN_HEIGHT * (NUM_SCREENS_Z/2.0));
	var ratio = Vector2(link_pos.x / (SCREEN_WIDTH * NUM_SCREENS_X), link_pos.y / (SCREEN_HEIGHT * NUM_SCREENS_Z));
	var inverse_screen = Vector2i(floori(ratio.x * NUM_SCREENS_X), floori(ratio.y*NUM_SCREENS_Z));
	return Vector2i(inverse_screen.x, (NUM_SCREENS_Z-1) - inverse_screen.y);

func within_load_dist(current_screen) -> bool:
	var link_pos = Vector2(link.global_position.x, link.global_position.z);
	var screen_v3_pos = screen_name_to_global_position(current_screen);
	var screen_pos = Vector2(screen_v3_pos.x, screen_v3_pos.z);
	var safe_width_dist = (SCREEN_WIDTH/2.0)-1.6;
	var safe_height_dist = (SCREEN_HEIGHT/2.0)-1.6;
	var within_width = link_pos.x < screen_pos.x + safe_width_dist and link_pos.x > screen_pos.x - safe_width_dist;
	var within_height = link_pos.y < screen_pos.y + safe_height_dist and link_pos.y > screen_pos.y - safe_height_dist;
	return within_width and within_height;

# Coverts links position into the name of the screen he is in
func get_current_screen_name() -> String:
	var screen_coord = get_current_screen();
	return "screen_" + str(screen_coord.y) + "_" + str(screen_coord.x);

func load_screen(screen_name):
	if screen:
		screen.queue_free();
	var screen_scene_path = SCREEN_SCENE_FOLDER_PATH + screen_name + ".tscn";
	var packed_screen: PackedScene = load(screen_scene_path);
	screen = packed_screen.instantiate();
	screen.position = screen_name_to_global_position(screen_name);
	call_deferred("add_child", screen);

func _process(_delta):
	if Engine.is_editor_hint(): return;
	var current_screen = get_current_screen_name();

	if not screen or (current_screen != screen.name.to_lower() and within_load_dist(current_screen)):
		load_screen(current_screen);
		var respawn_enemies = false;
		if not current_screen in screens_visited:
			respawn_enemies = true;
			screens_visited.push_back(current_screen);
			if len(screens_visited) > RESPAWN_UNIQUE_SCREEN_COUNT:
				screens_visited.pop_front();
		EnemyTracker.should_respawn[current_screen] = respawn_enemies;
