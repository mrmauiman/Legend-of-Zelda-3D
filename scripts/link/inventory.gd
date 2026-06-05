extends Node

enum ITEM_TYPES {NONE, LVL1, LVL2, LVL3};

const get_icon = {
	"sword": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/wooden_sword.png"),
			"ui_texture": preload("res://sprites/link/wooden_sword.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/white_sword.png"),
			"ui_texture": preload("res://sprites/link/white_sword.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL3: {
			"texture": preload("res://sprites/link/magic_sword_icon.png"),
			"ui_texture": preload("res://sprites/link/magic_sword_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"shield": {
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/shield.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"boomerang": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/boomerang.png"),
			"ui_texture": preload("res://sprites/ui/boomerang_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/magic_boomerang.png"),
			"ui_texture": preload("res://sprites/ui/magic_boomerang_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"bomb": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/bomb_1.png"),
			"ui_texture": preload("res://sprites/ui/bomb_icon.png"),
			"hframes": 5,
			"vframes": 2,
			"frame": 0,
			"flicker": false
		}
	},
	"bombs": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/link/bomb_1.png"),
			"capacity_texture": preload("res://sprites/link/bomb_capacity_ugrade.png"),
			"hframes": 5,
			"vframes": 2,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL3: {
			"texture": preload("res://sprites/link/bomb_1.png"),
			"capacity_texture": preload("res://sprites/link/bomb_capacity_ugrade.png"),
			"hframes": 5,
			"vframes": 2,
			"frame": 0,
			"flicker": false
		}
	},
	"bow": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/bow_item.png"),
			"ui_texture": preload("res://sprites/ui/bow_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"arrow": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/arrow.png"),
			"ui_texture": preload("res://sprites/ui/arrow_icon.png"),
			"hframes": 2,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/arrow.png"),
			"ui_texture": preload("res://sprites/ui/silver_arrow_icon.png"),
			"hframes": 2,
			"vframes": 1,
			"frame": 1,
			"flicker": false
		}
	},
	"candle": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/blue_candle.png"),
			"texture_no_flame": preload("res://sprites/blue_candle_item_no_flame.png"),
			"ui_texture": preload("res://sprites/ui/blue_candle_icon.png"),
			"ui_texture_no_flame": preload("res://sprites/ui/blue_candle_icon_no_flame.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/red_candle.png"),
			"ui_texture": preload("res://sprites/ui/red_candle_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"recorder": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/flute.png"),
			"ui_texture": preload("res://sprites/ui/recorder_icon.png"),
			"hframes": 6,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"food": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/link/food.png"),
			"ui_texture": preload("res://sprites/ui/food_icon.png"),
			"hframes": 4,
			"vframes": 5,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/food.png"),
			"ui_texture": preload("res://sprites/ui/food_icon.png"),
			"hframes": 4,
			"vframes": 5,
			"frame": 0,
			"flicker": false
		}
	},
	"letter": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/letter.png"),
			"ui_texture": preload("res://sprites/ui/letter_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"potion": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/blue_potion_icon.png"),
			"ui_texture": preload("res://sprites/ui/blue_potion_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/red_potion_icon.png"),
			"ui_texture": preload("res://sprites/ui/red_potion_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"magic_rod": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/magic_rod.png"),
			"ui_texture": preload("res://sprites/ui/magic_rod_icon.png"),
			"hframes": 4,
			"vframes": 2,
			"frame": 0,
			"flicker": false
		}
	},
	"raft": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/raft.png"),
			"ui_texture": preload("res://sprites/ui/raft_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"book_of_magic": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/book.png"),
			"ui_texture": preload("res://sprites/ui/book_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"ring": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/blue_ring.png"),
			"ui_texture": preload("res://sprites/ui/blue_ring_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		},
		ITEM_TYPES.LVL2: {
			"texture": preload("res://sprites/link/red_ring.png"),
			"ui_texture": preload("res://sprites/ui/red_ring_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"step_ladder": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/link/step_ladder.png"),
			"ui_texture": preload("res://sprites/ui/step_ladder_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"magic_key": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/lion_key.png"),
			"ui_texture": preload("res://sprites/ui/lion_key_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"power_bracelet": {
		ITEM_TYPES.LVL1: {
			"texture": preload("res://sprites/power_bracelet.png"),
			"ui_texture": preload("res://sprites/ui/power_bracelet_icon.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		}
	},
	"rupees": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/rupee.png"),
			"hframes": 2,
			"vframes": 1,
			"frame": 0,
			"flicker": "flicker01"
		} 
	},
	"heart": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/heart.png"),
			"hframes": 4,
			"vframes": 1,
			"frame": 0,
			"flicker": "flicker03"
		} 
	},
	"keys": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/key.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		} 
	},
	"heart_containers": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/heart_container.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		} 
	},
	"sword_scroll": {
		SWORD_SCROLLS.GREAT_SPIN_ATTACK: {
			"texture": preload("res://sprites/sword_scroll_1.png"),
			"pickup_texture": preload("res://sprites/sword_scroll_2.png"),
			"hframes": 3,
			"vframes": 2,
			"frame": 0,
			"flicker": false
		},
		SWORD_SCROLLS.SHIELD_STAB: {
			"texture": preload("res://sprites/sword_scroll_1.png"),
			"pickup_texture": preload("res://sprites/sword_scroll_2.png"),
			"hframes": 3,
			"vframes": 2,
			"frame": 1,
			"flicker": false
		},
		SWORD_SCROLLS.ROLL_ATTACK: {
			"texture": preload("res://sprites/sword_scroll_1.png"),
			"pickup_texture": preload("res://sprites/sword_scroll_2.png"),
			"hframes": 3,
			"vframes": 2,
			"frame": 2,
			"flicker": false
		},
		SWORD_SCROLLS.JUMP_OVER_ATTACK: {
			"texture": preload("res://sprites/sword_scroll_1.png"),
			"pickup_texture": preload("res://sprites/sword_scroll_2.png"),
			"hframes": 3,
			"vframes": 2,
			"frame": 3,
			"flicker": false
		},
		SWORD_SCROLLS.BACK_FLIP_ATTACK: {
			"texture": preload("res://sprites/sword_scroll_1.png"),
			"pickup_texture": preload("res://sprites/sword_scroll_2.png"),
			"hframes": 3,
			"vframes": 2,
			"frame": 4,
			"flicker": false
		},
		SWORD_SCROLLS.RISING_SPIN_ATTACK: {
			"texture": preload("res://sprites/sword_scroll_1.png"),
			"pickup_texture": preload("res://sprites/sword_scroll_2.png"),
			"hframes": 3,
			"vframes": 2,
			"frame": 5,
			"flicker": false
		}
	},
	"compass": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/compass.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		} 
	},
	"map": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/map.png"),
			"hframes": 1,
			"vframes": 1,
			"frame": 0,
			"flicker": false
		} 
	},
	"triforce_piece": {
		ITEM_TYPES.NONE: {
			"texture": preload("res://sprites/triforce_piece.png"),
			"hframes": 2,
			"vframes": 1,
			"frame": 0,
			"flicker": true
		} 
	}
};

var items: Dictionary = {
	"sword": ITEM_TYPES.LVL1,
	"shield": ITEM_TYPES.LVL2,
	"boomerang": ITEM_TYPES.LVL1,
	"bomb": ITEM_TYPES.LVL1,
	"bow": ITEM_TYPES.LVL1,
	"arrow": ITEM_TYPES.LVL2,
	"candle": ITEM_TYPES.LVL1,
	"recorder": ITEM_TYPES.LVL1,
	"food": ITEM_TYPES.LVL1,
	"letter": ITEM_TYPES.NONE,
	"potion": ITEM_TYPES.LVL2,
	"magic_rod": ITEM_TYPES.LVL1,
	"raft": ITEM_TYPES.LVL1,
	"book_of_magic": ITEM_TYPES.NONE,
	"ring": ITEM_TYPES.LVL1,
	"step_ladder": ITEM_TYPES.LVL1,
	"magic_key": ITEM_TYPES.LVL1,
	"power_bracelet": ITEM_TYPES.NONE
};

func add_to_counter(counter_id: String, amount: int):
	counters[counter_id] = min(counters[counter_id] + amount, counter_maxes[counter_id]);

var counters: Dictionary = {
	"heart_containers": 3,
	"rupees": 20,
	"bombs": 0,
	"keys": 0,
	"food": 10,
}

var display_rupees: int = 0;

var counter_maxes = {
	"heart_containers": 16,
	"rupees": 999,
	"bombs": 8,
	"keys": 99,
	"food": 10
};

var item_slots: Dictionary = {
	"item_1": "",
	"item_2": "",
	"item_3": ""
}

var pickup_locations_grabbed = [];

enum LEVELS {OVERWORLD, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE};

var levels: Dictionary = {
	LEVELS.OVERWORLD: {
		"compass": false,
		"map": false
	},
	LEVELS.ONE: {
		"triforce_piece": true,
		"compass": false,
		"map": false
	},
	LEVELS.TWO: {
		"triforce_piece": true,
		"compass": false,
		"map": false
	},
	LEVELS.THREE: {
		"triforce_piece": true,
		"compass": false,
		"map": false
	},
	LEVELS.FOUR: {
		"triforce_piece": true,
		"compass": false,
		"map": false
	},
	LEVELS.FIVE: {
		"triforce_piece": false,
		"compass": false,
		"map": false
	},
	LEVELS.SIX: {
		"triforce_piece": true,
		"compass": false,
		"map": false
	},
	LEVELS.SEVEN: {
		"triforce_piece": false,
		"compass": false,
		"map": false
	},
	LEVELS.EIGHT: {
		"triforce_piece": true,
		"compass": false,
		"map": false
	},
	LEVELS.NINE: {
		"compass": false,
		"map": false
	}
};

const LEVEL_BEGINNING_POSITIONS: Dictionary = {
	LEVELS.OVERWORLD: Vector3(-13.6, 0, 64),
	LEVELS.ONE: Vector3(-12.7, 0, 47.2),
	LEVELS.TWO: Vector3(-12.7, 0, 64.8),
	LEVELS.THREE: Vector3(25.6, 0, 48),
	LEVELS.FOUR: Vector3(-12.8, 0, 65.4),
	LEVELS.FIVE: Vector3(12.8, 0, 65.2),
	LEVELS.SIX: Vector3(-38.4, 0, 64.4),
	LEVELS.SEVEN: Vector3(-38.4, 0, 64.6),
	LEVELS.EIGHT: Vector3(25.6, 0, 64.8),
	LEVELS.NINE: Vector3(64, 0, 64.8)
};

const LEVEL_END_TELEPORT_POSITIONS: Dictionary = {
	LEVELS.OVERWORLD: Vector3(-13.6, 0, 64),
	LEVELS.ONE: Vector3(-13.6, 0, -7.6),
	LEVELS.TWO: Vector3(114.4, 12.8, -7.6),
	LEVELS.THREE: Vector3(-88.8, 0, 62),
	LEVELS.FOUR: Vector3(-63.2, 3.2, 9.2),
	LEVELS.FIVE: Vector3(88.8, 12.8, -59.5),
	LEVELS.SIX: Vector3(-140.7, 22.4, -24.4),
	LEVELS.SEVEN: Vector3(-144.8, 1.6, 11.9),
	LEVELS.EIGHT: Vector3(142.4, 1.6, 39.2),
	LEVELS.NINE: Vector3(-68, 16, -57.6)
}

func get_current_level_beginning():
	return LEVEL_BEGINNING_POSITIONS[current_level];

var sword_scrolls: Array = [true, true, true, true, true, true];
enum SWORD_SCROLLS {GREAT_SPIN_ATTACK, SHIELD_STAB, ROLL_ATTACK, JUMP_OVER_ATTACK, BACK_FLIP_ATTACK, RISING_SPIN_ATTACK};

func get_max_health():
	return hearts_to_health(counters.heart_containers);

var health = get_max_health();
var deaths: int = 0;

const HEART_HEALTH_VALUE := 256;
const HALF_HEART_HEALTH_VALUE: float = HEART_HEALTH_VALUE/2.0;

func hearts_to_health(hearts: float):
	return int(hearts * HEART_HEALTH_VALUE);

func take_damage(damage):
	EnemyDrops.reset_combo();
	var adjusted_damage = damage * 128;
	if items.ring == ITEM_TYPES.LVL1:
		adjusted_damage /= 2;
	elif items.ring == ITEM_TYPES.LVL2:
		adjusted_damage /= 4;
	health = clampi(health - adjusted_damage, 0, get_max_health());

func heal(hearts: float=-1):
	if hearts == -1:
		health = get_max_health();
	else:
		health = clampi(health + hearts_to_health(hearts), 0, get_max_health());

func get_half_heart_count() -> int:
	return ceili(float(health)/HALF_HEART_HEALTH_VALUE);

func full_health() -> bool:
	return (get_half_heart_count() * HALF_HEART_HEALTH_VALUE) == get_max_health();

func is_dead():
	return health <= 0;

var current_level: LEVELS = LEVELS.OVERWORLD;

enum CONTEXT_ACTIONS {NONE, ROLL, JUMP, JUMP_ATTACK, PLACE, THROW, PARRY};
var current_context: CONTEXT_ACTIONS = CONTEXT_ACTIONS.NONE;

var clock_timer: float = 0;

var rupee_sound: AudioStreamPlayer;

func _process(delta):
	if get_tree().current_scene is CanvasLayer: return;
	
	if clock_timer > 0:
		clock_timer -= delta;
	if display_rupees != counters.rupees:
		var diff = counters.rupees - display_rupees
		display_rupees += sign(diff);
		if not rupee_sound and (diff > 5 or diff < 0):
			rupee_sound = SoundSystem.play_global("res://audio/sfx/RupeeDecreaseLoop.ogg");
	elif rupee_sound:
		rupee_sound.stop();
		rupee_sound = null;
		SoundSystem.play_global("res://audio/sfx/RupeeDecreaseEnding.ogg");


var link: CharacterBody3D;
func get_link():
	if link: return link;

var unlocked_minimap_screens = {
	LEVELS.OVERWORLD: [],
	LEVELS.ONE: [],
	LEVELS.TWO: [],
	LEVELS.THREE: [],
	LEVELS.FOUR: [],
	LEVELS.FIVE: [],
	LEVELS.SIX: [],
	LEVELS.SEVEN: [],
	LEVELS.EIGHT: [],
	LEVELS.NINE: [],
};

@warning_ignore("unused_signal")
signal recorded_played;

var recorder_current_teleport;
func set_teleport(dir):
	if not recorder_current_teleport:
		for level in levels:
			if not levels[level].has("triforce_piece"): continue;
			if levels[level].triforce_piece:
				recorder_current_teleport = level;
				return;
		recorder_current_teleport = LEVELS.OVERWORLD;
		return;
	
	var start = recorder_current_teleport;
	while true:
		recorder_current_teleport += dir;
		if recorder_current_teleport == LEVELS.OVERWORLD: recorder_current_teleport = LEVELS.EIGHT;
		if recorder_current_teleport == LEVELS.NINE: recorder_current_teleport = LEVELS.ONE;
		if levels[recorder_current_teleport].triforce_piece:
			return;
		if recorder_current_teleport == start:
			recorder_current_teleport = LEVELS.OVERWORLD;
			return;

var level_7_revealed: bool = false;

var link_name: String = "LINK";

var door_repairs_visited: Array = [];

# SAVING AND LOADING
func save_data(slot):
	var data: Dictionary = {
		"items": items,
		"counters": counters,
		"max_bombs": counter_maxes.bombs,
		"item_slots": item_slots,
		"levels": levels,
		"sword_scrolls": sword_scrolls,
		"health": health,
		"deaths": deaths,
		"current_level": current_level,
		"unlocked_minimap_screens": unlocked_minimap_screens,
		"recorder_current_teleport": recorder_current_teleport,
		"level_7_revealed": level_7_revealed,
		"link_name": link_name,
		"pickup_locations_grabbed": pickup_locations_grabbed,
		"door_repairs_visited": door_repairs_visited,
	};
	var data_string = JSON.stringify(data);
	var save_file = FileAccess.open("user://"+slot+"/inventory.save", FileAccess.WRITE);
	save_file.store_line(data_string);

func fix_level_keys(dict):
	var rv = {};
	for key in dict:
		rv[int(key)] = dict[key];
	return rv;

func fix_int_values(dict):
	var rv = {};
	for key in dict:
		rv[key] = int(dict[key]);
	return rv;

var current_slot: String = "";
func load_data(slot):
	if not FileAccess.file_exists("user://"+slot+"/inventory.save"):
		return;
	
	var save_file = FileAccess.open("user://"+slot+"/inventory.save", FileAccess.READ);
	var data_string = save_file.get_line();
	var json = JSON.new();
	var parse_result = json.parse(data_string);
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data_string, " at line ", json.get_error_line());
		return;
	var data = json.data;
	
	items = fix_int_values(data.items);
	counters = fix_int_values(data.counters);
	if not counters.has("food"):
		if items.food == Inventory.ITEM_TYPES.LVL1:
			counters.food = 10;
		else:
			counters.food = 0;
	if items.food == ITEM_TYPES.NONE:
		items.food = ITEM_TYPES.LVL1;
	if data.has("max_bombs"): counter_maxes.bombs = int(data.max_bombs);
	display_rupees = counters.rupees;
	item_slots = data.item_slots;
	levels = fix_level_keys(data.levels);
	sword_scrolls = data.sword_scrolls;
	var data_health = int(data.health);
	if data_health <= 0:
		data_health = hearts_to_health(3);
	health = data_health;
	deaths = int(data.deaths);
	current_level = int(data.current_level) as Inventory.LEVELS;
	unlocked_minimap_screens = fix_level_keys(data.unlocked_minimap_screens);
	recorder_current_teleport = int(data.recorder_current_teleport);
	level_7_revealed = data.level_7_revealed;
	link_name = data.link_name;
	current_slot = slot;
	
	if data.has("pickup_locations_grabbed"):
		pickup_locations_grabbed = data.pickup_locations_grabbed;
	else:
		# Previous Save data not supported
		pickup_locations_grabbed = [];
	
	if data.has("door_repairs_visited"):
		door_repairs_visited = data.door_repairs_visited;
	else:
		door_repairs_visited = [];
	
var candle_available: bool = true;

func _input(event):
	if event.is_action_pressed("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
