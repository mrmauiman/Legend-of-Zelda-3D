extends Button

const BLANK_FRAME = 47;
const HEART_FRAME = 46;
const SKULL_FRAME = 34;
const LETTER_MAP = {
	"A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7, "I": 8, "J": 9,
	"K": 10, "L": 11, "M": 12, "N": 13, "O": 14, "P": 15, "Q": 16, "R": 17, "S": 18, "T": 19,
	"U": 20, "V": 21, "W": 22, "X": 23, "Y": 24, "Z": 25, "-": 26, ".": 27, ",": 28, "!": 29,
	"'": 30, "&": 31, "|": 32, "^": 33, "@": 34, "0": 36, "1": 37, "2": 38, "3": 39,
	"4": 40, "5": 41, "6": 42, "7": 43, "8": 44, "9": 45, " ": 47
};

const LEVELS: Dictionary = {
	Inventory.LEVELS.OVERWORLD: "res://scenes/chunked_worlds/overworld/overworld.tscn",
	Inventory.LEVELS.ONE: "res://scenes/environment/dungeons/level_1.tscn",
	Inventory.LEVELS.TWO: "res://scenes/environment/dungeons/level_2.tscn",
	Inventory.LEVELS.THREE: "res://scenes/environment/dungeons/level_3.tscn",
	Inventory.LEVELS.FOUR: "res://scenes/environment/dungeons/level_4.tscn",
	Inventory.LEVELS.FIVE: "res://scenes/environment/dungeons/level_5.tscn",
	Inventory.LEVELS.SIX: "res://scenes/environment/dungeons/level_6.tscn",
	Inventory.LEVELS.SEVEN: "res://scenes/environment/dungeons/level_7.tscn",
	Inventory.LEVELS.EIGHT: "res://scenes/environment/dungeons/level_8.tscn",
	Inventory.LEVELS.NINE: "res://scenes/environment/dungeons/level_9.tscn"
};

@onready var selector: Sprite2D = $Selector;
@onready var link_icon: Sprite2D = $LinkIcon;
@onready var name_text: Node2D = $Name;
@onready var death_count: Node2D = $DeathCount;
@onready var hearts: Node2D = $Hearts;
@onready var overlay: Sprite2D = $Overlay;

var has_save: bool = false;

func display_tunic(type: Inventory.ITEM_TYPES):
	link_icon.frame = type;

func display_name(link_name: String):
	link_name = link_name.to_upper();
	var i = 0;
	for letter in name_text.get_children():
		if i >= len(link_name) or not LETTER_MAP.has(link_name[i]):
			letter.frame = BLANK_FRAME;
		else:
			letter.frame = LETTER_MAP[link_name[i]];
		i+=1;

func display_deaths(deaths: int):
	deaths = min(deaths, 999);
	if deaths >= 100:
		@warning_ignore("integer_division")
		death_count.get_node("Letter1").frame = LETTER_MAP[str(deaths/100)];
	else:
		death_count.get_node("Letter1").frame = BLANK_FRAME;
	if deaths >= 10:
		@warning_ignore("integer_division")
		death_count.get_node("Letter2").frame = LETTER_MAP[str(deaths/10)[-1]];
	else:
		death_count.get_node("Letter2").frame = BLANK_FRAME;
	death_count.get_node("Letter3").frame = LETTER_MAP[str(deaths)[-1]];
	death_count.get_node("Letter4").frame = SKULL_FRAME;

func display_hearts(heart_count: int):
	var i = 0;
	for heart in hearts.get_children():
		if i < heart_count:
			heart.frame = HEART_FRAME;
		else:
			heart.frame = BLANK_FRAME;
		i+=1;

func display_empty_slot():
	link_icon.frame = 3;
	display_name("NEW GAME");
	for letter in death_count.get_children():
		letter.frame = BLANK_FRAME;
	for heart in hearts.get_children():
		heart.frame = BLANK_FRAME;

func get_display_data():
	if not DirAccess.dir_exists_absolute("user://" + name.to_lower()):
		display_empty_slot();
		has_save = false;
		return;
	
	if not FileAccess.file_exists("user://"+name.to_lower()+"/inventory.save"):
		return;
	
	has_save = true;
	
	var save_file = FileAccess.open("user://"+name.to_lower()+"/inventory.save", FileAccess.READ);
	var data_string = save_file.get_line();
	var json = JSON.new();
	var parse_result = json.parse(data_string);
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data_string, " at line ", json.get_error_line());
		return;
	var data = json.data;
	
	display_tunic(data.items.ring);
	display_name(data.link_name);
	display_deaths(data.deaths);
	display_hearts(data.counters.heart_containers);


func _on_focus_entered():
	if disabled: return;
	for node in get_parent().get_children():
		if node is Button:
			node.disabled = false;
			node.mouse_filter = Control.MOUSE_FILTER_STOP;
	if overlay.visible: 
		disabled = true;
		set_deferred("disabled", false);
	overlay.visible = false;
	selector.frame = HEART_FRAME;
	SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");

func _on_focus_exited():
	selector.frame = BLANK_FRAME;


func _on_pressed():
	if disabled: return;
	if not has_save:
		get_parent().get_parent().get_node("RegisterName").show_panel(name);
		get_parent().hide_panel();
	else:
		overlay.visible = true;
		overlay.get_node("Play").grab_focus();
		for node in get_parent().get_children():
			if node is Button and node != self:
				node.disabled = true;
				node.mouse_filter = Control.MOUSE_FILTER_IGNORE;

func _ready():
	overlay.get_node("Play").pressed.connect(play);
	overlay.get_node("Delete").pressed.connect(delete);

func play():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	get_parent().get_parent().get_node("ColorRect").z_index = 10;
	call_deferred("load_level");

func load_level():
	Inventory.load_data(name.to_lower());
	EnemyTracker.load_data(name.to_lower());
	Randomizer.load_data(name.to_lower());
	get_tree().change_scene_to_file(LEVELS[Inventory.current_level]);

func remove_dir(path: String):
	var dir = DirAccess.open(path);
	if dir:
		dir.list_dir_begin();
		var file_name = dir.get_next();
		while file_name != "":
			if dir.current_is_dir():
				remove_dir(path+"/"+file_name);
			else:
				dir.remove(file_name);
			file_name = dir.get_next();
		DirAccess.remove_absolute(path);

func delete():
	if not DirAccess.dir_exists_absolute("user://"+name.to_lower()):
		get_parent().show_panel();
		return;
	
	remove_dir("user://"+name.to_lower());
	get_parent().show_panel();
	grab_focus();
