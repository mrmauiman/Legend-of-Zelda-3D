extends Node2D

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

@onready var letter_selector: LetterSelector = get_node("Name/LetterSelector");

var save_slot: String = "";

func _process(_delta):
	position.x = (get_viewport_rect().size.x/2.0) - (1920.0/2.0);

func show_panel(slot):
	$Letters/A.grab_focus();
	letter_selector.current_letter = 1;
	for i in range(8):
		var letter = get_node("Name/Letter"+str(i+1));
		letter.frame = BLANK_FRAME;
	save_slot = slot.to_lower();
	visible = true

func hide_panel():
	visible = false;

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			var base_input = OS.get_keycode_string(event.key_label);
			if len(base_input) == 1 and Input.is_key_pressed(KEY_SHIFT):
				if base_input == "1":
					base_input = "!";
				elif base_input == "2":
					base_input = "@";
				elif base_input == "6":
					base_input = "^";
				elif base_input == "7":
					base_input = "&";
			elif len(base_input) > 1:
				if base_input == "Minus":
					base_input = "-";
				elif base_input == "Period":
					base_input = ".";
				elif base_input == "Comma":
					base_input = ",";
				elif base_input == "Apostrophe":
					base_input = "'";
				elif base_input == "BackSlash" and Input.is_key_pressed(KEY_SHIFT):
					base_input = "|";
				elif base_input == "Space":
					base_input = " ";
				else:
					return;
			select_letter(base_input);

func select_letter(letter: String):
	letter = letter.to_upper();
	var frame = BLANK_FRAME;
	if LETTER_MAP.has(letter):
		frame = LETTER_MAP[letter];
	get_node("Name/Letter"+str(letter_selector.current_letter)).frame = frame;
	letter_selector.current_letter += 1;

func get_inputed_name() -> String:
	var inputed_name: String = "";
	for letter in get_node("Name").get_children():
		for key in LETTER_MAP:
			if LETTER_MAP[key] == letter.frame:
				inputed_name += key;
				break;
	return inputed_name.strip_edges(false, true).to_upper();

func create_save(save_name: String):
	# Make slot folder
	DirAccess.make_dir_absolute("user://" + save_slot);
	
	# Make new inventory
	var data: Dictionary = {
		"items": {
			"sword": Inventory.ITEM_TYPES.NONE,
			"shield": Inventory.ITEM_TYPES.LVL1,
			"boomerang": Inventory.ITEM_TYPES.NONE,
			"bomb": Inventory.ITEM_TYPES.LVL1,
			"bow": Inventory.ITEM_TYPES.NONE,
			"arrow": Inventory.ITEM_TYPES.NONE,
			"candle": Inventory.ITEM_TYPES.NONE,
			"recorder": Inventory.ITEM_TYPES.NONE,
			"food": Inventory.ITEM_TYPES.LVL1,
			"letter": Inventory.ITEM_TYPES.NONE,
			"potion": Inventory.ITEM_TYPES.NONE,
			"magic_rod": Inventory.ITEM_TYPES.NONE,
			"raft": Inventory.ITEM_TYPES.NONE,
			"book_of_magic": Inventory.ITEM_TYPES.NONE,
			"ring": Inventory.ITEM_TYPES.NONE,
			"step_ladder": Inventory.ITEM_TYPES.NONE,
			"magic_key": Inventory.ITEM_TYPES.NONE,
			"power_bracelet": Inventory.ITEM_TYPES.NONE
		},
		"counters": {
			"heart_containers": 3,
			"rupees": 0,
			"bombs": 0,
			"keys": 0,
			"food": 0
		},
		"max_bombs": 8,
		"item_slots": {
			"item_1": "",
			"item_2": "",
			"item_3": ""
		},
		"levels": {
			Inventory.LEVELS.OVERWORLD: {
				"heart_container": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.ONE: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.TWO: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.THREE: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.FOUR: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.FIVE: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.SIX: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.SEVEN: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.EIGHT: {
				"heart_container": false,
				"triforce_piece": false,
				"compass": false,
				"map": false
			},
			Inventory.LEVELS.NINE: {
				"compass": false,
				"map": false
			}
		},
		"heart_conatiner_caves": [false, false, false, false],
		"sword_scrolls": [false, false, false, false, false, false],
		"health": Inventory.hearts_to_health(3),
		"deaths": 0,
		"current_level": Inventory.LEVELS.OVERWORLD,
		"unlocked_minimap_screens": {
			Inventory.LEVELS.OVERWORLD: [],
			Inventory.LEVELS.ONE: [],
			Inventory.LEVELS.TWO: [],
			Inventory.LEVELS.THREE: [],
			Inventory.LEVELS.FOUR: [],
			Inventory.LEVELS.FIVE: [],
			Inventory.LEVELS.SIX: [],
			Inventory.LEVELS.SEVEN: [],
			Inventory.LEVELS.EIGHT: [],
			Inventory.LEVELS.NINE: [],
		},
		"recorder_current_teleport": 0,
		"level_7_revealed": false,
		"link_name": save_name
	};
	var data_string = JSON.stringify(data);
	var save_file = FileAccess.open("user://"+save_slot+"/inventory.save", FileAccess.WRITE);
	save_file.store_line(data_string);
	
	# Make new Enemy Tracker
	var et_data: Dictionary = {
		"screens": {},
		"should_respawn": {},
		"dungeons": {
			Inventory.LEVELS.ONE: {},
			Inventory.LEVELS.TWO: {},
			Inventory.LEVELS.THREE: {},
			Inventory.LEVELS.FOUR: {},
			Inventory.LEVELS.FIVE: {},
			Inventory.LEVELS.SIX: {},
			Inventory.LEVELS.SEVEN: {},
			Inventory.LEVELS.EIGHT: {},
			Inventory.LEVELS.NINE: {}
		},
		"dungeon_rooms_visited": []
	};
	var et_data_string = JSON.stringify(et_data);
	var et_save_file = FileAccess.open("user://"+save_slot+"/enemy_tracker.save", FileAccess.WRITE);
	et_save_file.store_line(et_data_string);
	
	# Make Randomizer Data
	var root = get_parent();
	var randomize_choice: OptionButton = root.get_node("%RandomizeSave");
	if not randomize_choice.selected == 0: return;
	var r_data: Dictionary = {
		"seed": root.get_node("%RandomizerSeed").text,
		"item_randomization": root.get_node("%ItemRandomizationType").selected,
		"wood_sword": (root.get_node("%RandomizeWoodSword").selected == 0),
		"caves": (root.get_node("%RandomizeCaves").selected == 0),
		"dungeons": (root.get_node("%RandomizeDungeons").selected == 0),
		"enemies": (root.get_node("%RandomizeEnemies").selected == 0),
		"shops": (root.get_node("%RandomizeShops").selected == 0)
	};
	var r_data_string = JSON.stringify(r_data);
	var r_save_file = FileAccess.open("user://"+save_slot+"/randomizer.save", FileAccess.WRITE);
	r_save_file.store_line(r_data_string);

func nav_to_file_select():
	get_parent().get_node("FileSelect").show_panel();
	hide_panel();

func _on_confirm_pressed():
	var save_name := get_inputed_name();
	if len(save_name) == 0: return;
	create_save(save_name);
	nav_to_file_select();
