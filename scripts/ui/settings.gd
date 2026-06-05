extends Node

var auto_detect_controller_type: bool = true;

var music_volume = 0.3:
	set(val):
		music_volume = val;
		SoundSystem.update_music_volume();

var sfx_volume = 0.3;

enum CONTROLLER_TYPES {MOUSE_AND_KEYBOARD, SWITCH, XBOX, PLAYSTATION};
var controller_type = CONTROLLER_TYPES.MOUSE_AND_KEYBOARD;

var current_controller = 0;

var camera_x_inverted: bool = false;
var camera_y_inverted: bool = false;
var camera_sensitivity: float = 0.5;
var camera_zoom: float = 5.0;

enum TARGET_MODES {HOLD, TOGGLE};
var target_mode = TARGET_MODES.HOLD;

enum SOUND_TRACK {ENHANCED, ORIGINAL};
var sound_track = SOUND_TRACK.ENHANCED;

var low_health_sound: bool = true;
var low_health_timer: float = 0;
const LOW_HEALTH_TIME: float = 1;

enum GRAPHICS {LOW, HIGH};
var graphics_mode = GRAPHICS.HIGH:
	set(val):
		graphics_mode = val;
		graphics_changed.emit();
signal graphics_changed;

func _process(delta):
	low_health_timer -= delta;
	if low_health_timer <= 0:
		low_health_timer += LOW_HEALTH_TIME;
		if low_health_sound and Inventory.get_half_heart_count() <= 2:
			SoundSystem.play_global("res://audio/sfx/low_health_sound.wav");

func save():
	var data = {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"sound_track": sound_track,
		"low_health_sound": low_health_sound,
		"graphics_mode": graphics_mode,
		"auto_detect_controller_type": auto_detect_controller_type,
		"controller_type": controller_type,
		"camera_x_inverted": camera_x_inverted,
		"camera_y_inverted": camera_y_inverted,
		"camera_sensitivity": camera_sensitivity,
		"camera_zoom": camera_zoom,
		"target_mode": target_mode,
	};
	var data_string = JSON.stringify(data);
	var save_file = FileAccess.open("user://settings.save", FileAccess.WRITE);
	save_file.store_line(data_string);

func load_data():
	if not FileAccess.file_exists("user://settings.save"): return;
	var save_file = FileAccess.open("user://settings.save", FileAccess.READ);
	var data_string = save_file.get_line();
	var json = JSON.new();
	var parse_result = json.parse(data_string);
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data_string, " at line ", json.get_error_line());
		return;
	var data = json.data;
	music_volume = data.music_volume;
	sfx_volume = data.sfx_volume;
	auto_detect_controller_type = data.auto_detect_controller_type;
	controller_type = int(data.controller_type) as CONTROLLER_TYPES;
	camera_x_inverted = data.camera_x_inverted;
	camera_y_inverted = data.camera_y_inverted;
	camera_sensitivity = data.camera_sensitivity;
	if data.has("target_mode"):
		target_mode = int(data.target_mode) as TARGET_MODES;
	if data.has("camera_zoom"):
		camera_zoom = data.camera_zoom;
	if data.has("sound_track"):
		sound_track = int(data.sound_track) as SOUND_TRACK;
	if data.has("low_heath_sound"):
		low_health_sound = data.low_health_sound;
	if data.has("graphics_mode"):
		graphics_mode = int(data.graphics_mode) as GRAPHICS;

func _ready():
	load_data();
	if Input.get_connected_joypads().size() > 0:
		controller_type = _get_controller_type(current_controller);

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion and abs(event.axis_value) < 0.1: return;
		var type = _get_controller_type(event.device);
		if type != controller_type:
			controller_type = type;


func _get_controller_type(device_id):
	if not auto_detect_controller_type: return controller_type;
	var controller_name: String = Input.get_joy_name(device_id).to_lower();
	#print(controller_name);
	# Check the name for specific keywords
	if controller_name.contains("xbox") or controller_name.contains("xinput"):
		#print("This is an Xbox-style controller.")
		return CONTROLLER_TYPES.XBOX;
	elif controller_name.contains("playstation") or controller_name.contains("dualshock") or controller_name.contains("dualsense") or controller_name.contains("ps"):
		#print("This is a PlayStation-style controller.")
		return CONTROLLER_TYPES.PLAYSTATION;
	elif controller_name.contains("pro controller") or controller_name.contains("switch"):
		#print("This is a Nintendo Switch-style controller.")
		return CONTROLLER_TYPES.SWITCH;
	else:
		return CONTROLLER_TYPES.MOUSE_AND_KEYBOARD;
