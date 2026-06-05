extends Node

var screens := {};
var should_respawn := {};

func add_screen_data(screen, screen_data):
	screens[screen] = screen_data;

func get_screen_data(screen):
	return screens[screen];

func has_screen_data(screen):
	return screens.has(screen);

var overworld_doors;

var dungeons := {
	Inventory.LEVELS.ONE: {},
	Inventory.LEVELS.TWO: {},
	Inventory.LEVELS.THREE: {},
	Inventory.LEVELS.FOUR: {},
	Inventory.LEVELS.FIVE: {},
	Inventory.LEVELS.SIX: {},
	Inventory.LEVELS.SEVEN: {},
	Inventory.LEVELS.EIGHT: {},
	Inventory.LEVELS.NINE: {}
};

const ROOM_RESPAWN_COUTNER: int = 7;
var dungeon_rooms_visited: Array = [];

func dungeon_room_visited_recently(room_name) -> bool:
	for room in dungeon_rooms_visited:
		if room == room_name:
			return true;
	
	if len(dungeon_rooms_visited) == ROOM_RESPAWN_COUTNER:
		dungeon_rooms_visited.pop_front();
	dungeon_rooms_visited.push_back(room_name);
	return false;

func reset_dungeon_data_on_enter(level: Inventory.LEVELS):
	for room in dungeons[level]:
		if dungeons[level][room].has("enemies"):
			for enemy in dungeons[level][room].enemies:
				dungeons[level][room].enemies[enemy] = false;
	dungeon_rooms_visited = [];

# Cave Data
var secret_caves: Array = [];


func save_data(slot):
	var data: Dictionary = {
		"screens": screens,
		"should_respawn": should_respawn,
		"dungeons": dungeons,
		"dungeon_rooms_visited": dungeon_rooms_visited,
		"secret_caves": secret_caves,
		"overworld_doors": overworld_doors
	};
	var data_string = JSON.stringify(data);
	var save_file = FileAccess.open("user://"+slot+"/enemy_tracker.save", FileAccess.WRITE);
	save_file.store_line(data_string);

func fix_level_keys(dict):
	var rv = {};
	for key in dict:
		rv[int(key)] = dict[key];
	return rv;

func load_data(slot):
	if not FileAccess.file_exists("user://"+slot+"/enemy_tracker.save"):
		overworld_doors = null;
		screens = {};
		should_respawn = {};
		return;
	
	var save_file = FileAccess.open("user://"+slot+"/enemy_tracker.save", FileAccess.READ);
	var data_string = save_file.get_line();
	var json = JSON.new();
	var parse_result =  json.parse(data_string);
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data_string, " at line ", json.get_error_line());
		return;
	var data = json.data;
	
	screens = data.screens;
	should_respawn = data.should_respawn;
	dungeons = fix_level_keys(data.dungeons);
	dungeon_rooms_visited = data.dungeon_rooms_visited;
	if data.has("secret_caves"):
		secret_caves = data.secret_caves;
	else:
		secret_caves = [];
	if data.has("overworld_doors"):
		overworld_doors = data.overworld_doors;
	else:
		overworld_doors = null;
