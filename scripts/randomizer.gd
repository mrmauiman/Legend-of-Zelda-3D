extends Node

var randomizer_seed: String = "";
var random: RandomNumberGenerator = RandomNumberGenerator.new();

const TOTAL_KEYS = 45;

# Settings
enum ITEM_RANDOMIZATIONS {ITEMS_ONLY, FULL_RANDOMIZATION};
var randomize_wood_sword: bool = true;
var do_random_caves: bool = true;
var do_random_dungeon_locations: bool = true;
var do_random_enemies: bool = true;
var do_random_shops: bool = true;
var item_randomization: ITEM_RANDOMIZATIONS = ITEM_RANDOMIZATIONS.FULL_RANDOMIZATION;

var default_caves_map: Dictionary = {
	"screen_0_0": "cave_0_0",
	"screen_0_1": "secret_cave_30/0",
	"screen_0_5": "cave_0_5",
	"screen_0_6": "money_game_cave",
	"screen_0_7": "wooden_sword_cave",
	"screen_0_8": "potion_cave",
	"screen_0_9": "fast_travel_cave/0",
	"screen_0_10": "sword_scroll_cave/0",
	"screen_0_11": "potion_or_heart_container_cave/0",
	"screen_0_12": "money_game_cave",
	"screen_0_13": "door_repair_cave/0",
	"screen_1_2": "secret_cave_100/0",
	"screen_1_3": "door_repair_cave/1",
	"screen_1_4": "potion_cave",
	"screen_1_6": "shop_1_cave",
	"screen_1_7": "secret_cave_30/1",
	"screen_1_8": "door_repair_cave/2",
	"screen_1_10": "door_repair_cave/3",
	"screen_1_11": "secret_cave_100/1",
	"screen_1_15": "shop_2_cave",
	"screen_2_1": "secret_cave_10/0",
	"screen_2_6": "secret_cave_10/1",
	"screen_2_11": "secret_cave_10/2",
	"screen_2_14": "shop_1_cave",
	"screen_3_4": "shop_1_cave",
	"screen_3_6": "shop_3_cave",
	"screen_3_7": "potion_or_heart_container_cave/1",
	"screen_3_8": "secret_cave_30/2",
	"screen_3_9": "fast_travel_cave/3",
	"screen_3_10": "shop_2_cave",
	"screen_3_11": "potion_cave",
	"screen_3_13": "shop_3_cave",
	"screen_3_14": "secret_cave_10/3",
	"screen_3_15": "sword_scroll_cave/1",
	"screen_4_3": "potion_cave",
	"screen_4_4": "shop_4_cave",
	"screen_4_13": "secret_cave_30/3",
	"screen_5_1": "magic_sword_cave",
	"screen_5_3": "fast_travel_cave/2",
	"screen_5_5": "shop_2_cave",
	"screen_5_6": "shop_3_cave",
	"screen_5_7": "potion_cave",
	"screen_5_8": "secret_cave_30/4",
	"screen_5_12": "potion_or_heart_container_cave/2",
	"screen_5_13": "secret_cave_30/5",
	"screen_5_15": "potion_or_heart_container_cave/3",
	"screen_6_0": "money_game_cave",
	"screen_6_1": "sword_scroll_cave/2",
	"screen_6_2": "shop_3_cave",
	"screen_6_3": "secret_cave_30/6",
	"screen_6_4": "door_repair_cave/4",
	"screen_6_6": "money_game_cave",
	"screen_6_10": "cave_6_10",
	"screen_6_12": "cave_6_12",
	"screen_6_13": "fast_travel_cave/1",
	"screen_6_14": "door_repair_cave/5",
	"screen_6_15": "money_game_cave",
	"screen_7_1": "door_repair_cave/6",
	"screen_7_3": "door_repair_cave/7",
	"screen_7_4": "potion_cave",
	"screen_7_7": "door_repair_cave/8",
	"screen_7_10": "white_sword_cave",
	"screen_7_12": "shop_1_cave",
	"screen_7_13": "potion_cave",
	"screen_7_14": "letter_cave",
	"screen_7_15": "secret_cave_100/2"
};

var caves_map = {};

var default_dungeons_map = {
	"entrance_1": "level_1",
	"entrance_2": "level_2",
	"entrance_3": "level_3",
	"entrance_4": "level_4",
	"entrance_5": "level_5",
	"entrance_6": "level_6",
	"entrance_7": "level_7",
	"entrance_8": "level_8",
	"entrance_9": "level_9",
};

var dungeons_map = {};

var overworld_enemy_pool = ["ghini", "leever", "leever_blue", "lynel", "lynel_blue", "moblin", "moblin_blue", "octorock", "octorock_blue", "peahat", "tektite", "tektite_blue"];
var static_enemy_pool = ["armos", "rock_slide_area", "zora"];

var default_overworld_enemies_map = {
	"screen_0_0": ["peahat", "peahat", "peahat", "peahat"],
	"screen_0_1": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_0_2": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin"],
	"screen_0_3": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_0_4": ["tektite"],
	"screen_0_5": ["peahat", "peahat", "peahat", "leever", "leever_blue", "leever_blue", "zora"],
	"screen_0_6": ["tektite", "tektite", "tektite", "tektite"],
	"screen_0_7": [],
	"screen_0_8": ["octorock", "octorock", "octorock", "octorock"],
	"screen_0_9": ["tektite_blue", "tektite_blue", "tektite_blue", "tektite_blue", "tektite_blue"],
	"screen_0_10": ["tektite_blue", "tektite_blue", "tektite_blue", "tektite_blue"],
	"screen_0_11": ["leever", "leever", "leever", "leever", "leever", "leever", "zora"],
	"screen_0_12": ["leever", "leever", "leever", "leever", "leever", "leever", "zora"],
	"screen_0_13": ["octorock_blue", "octorock_blue", "octorock_blue", "octorock_blue", "zora"],
	"screen_0_14": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_0_15": ["octorock_blue", "zora"],
	"screen_1_0": ["peahat", "peahat", "lynel", "lynel", "lynel_blue", "lynel_blue"],
	"screen_1_1": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_1_2": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_1_3": ["moblin", "moblin", "moblin", "moblin_blue", "octorock_blue", "octorock_blue"],
	"screen_1_4": ["octorock", "octorock", "octorock", "octorock_blue", "octorock_blue"],
	"screen_1_5": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_1_6": ["octorock", "octorock", "octorock", "octorock"],
	"screen_1_7": ["octorock", "octorock", "octorock", "octorock"],
	"screen_1_8": ["octorock", "octorock", "octorock", "octorock"],
	"screen_1_9": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_1_10": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_1_11": ["moblin", "moblin", "moblin", "moblin_blue", "octorock_blue", "octorock_blue"],
	"screen_1_12": ["moblin", "moblin", "moblin", "moblin"],
	"screen_1_13": ["moblin", "moblin", "moblin", "moblin"],
	"screen_1_14": ["moblin", "moblin", "moblin", "moblin_blue", "octorock_blue", "octorock_blue"],
	"screen_1_15": ["octorock", "octorock", "octorock", "octorock", "octorock_blue", "zora"],
	"screen_2_0": ["lynel", "lynel", "lynel", "lynel", "lynel"],
	"screen_2_1": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_2_2": ["moblin", "moblin", "moblin_blue", "moblin_blue"],
	"screen_2_3": ["moblin", "moblin", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_2_4": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_2_5": ["octorock", "zora"],
	"screen_2_6": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_2_7": ["octorock", "octorock", "octorock", "octorock"],
	"screen_2_8": ["octorock", "octorock", "octorock", "octorock"],
	"screen_2_9": ["peahat", "peahat", "peahat", "peahat", "zora"],
	"screen_2_10": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_2_11": ["moblin", "moblin", "moblin_blue", "moblin_blue"],
	"screen_2_12": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_2_13": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_2_14": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_2_15": ["octorock", "octorock", "octorock", "octorock_blue", "octorock_blue", "zora"],
	"screen_3_0": ["ghini"],
	"screen_3_1": ["ghini"],
	"screen_3_2": ["moblin"],
	"screen_3_3": [],
	"screen_3_4": ["octorock", "octorock", "octorock", "octorock", "zora"],
	"screen_3_5": ["peahat"],
	"screen_3_6": ["zora"],
	"screen_3_7": ["zora"],
	"screen_3_8": ["leever", "leever", "leever", "leever", "zora"],
	"screen_3_9": ["octorock", "octorock", "octorock", "octorock", "octorock", "octorock_blue"],
	"screen_3_10": ["tektite_blue", "tektite_blue", "tektite_blue", "tektite_blue", "tektite_blue", "tektite_blue"],
	"screen_3_11": ["moblin", "moblin", "moblin", "moblin", "moblin", "moblin"],
	"screen_3_12": ["octorock", "octorock", "octorock", "octorock_blue", "octorock_blue"],
	"screen_3_13": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_3_14": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_3_15": ["octorock", "octorock", "octorock", "octorock_blue", "octorock_blue", "zora"],
	"screen_4_0": ["ghini"],
	"screen_4_1": ["ghini"],
	"screen_4_2": ["peahat", "peahat", "lynel", "lynel", "lynel_blue", "lynel_blue"],
	"screen_4_3": [],
	"screen_4_4": ["leever_blue", "leever_blue", "leever_blue", "leever_blue", "zora"],
	"screen_4_5": ["zora"],
	"screen_4_6": ["zora"],
	"screen_4_7": ["octorock"],
	"screen_4_8": ["octorock", "octorock", "octorock", "octorock", "octorock", "octorock_blue", "zora"],
	"screen_4_9": [],
	"screen_4_10": ["peahat", "peahat", "peahat", "leever", "leever_blue", "leever_blue"],
	"screen_4_11": ["leever_blue", "leever_blue", "leever_blue", "leever_blue"],
	"screen_4_12": ["octorock_blue"],
	"screen_4_13": ["moblin_blue", "moblin_blue", "moblin_blue", "moblin_blue"],
	"screen_4_14": ["octorock", "octorock", "octorock", "octorock_blue", "octorock_blue", "zora"],
	"screen_4_15": ["octorock_blue", "zora"],
	"screen_5_0": ["ghini"],
	"screen_5_1": ["ghini"],
	"screen_5_2": ["lynel"],
	"screen_5_3": ["lynel", "lynel", "lynel", "lynel"],
	"screen_5_4": [],
	"screen_5_5": ["peahat", "peahat", "peahat", "peahat"],
	"screen_5_6": ["peahat", "peahat", "peahat", "peahat", "peahat", "peahat", "zora"],
	"screen_5_7": ["peahat", "peahat", "peahat", "peahat", "peahat", "peahat", "zora"],
	"screen_5_8": ["peahat", "peahat", "peahat", "peahat", "peahat", "peahat", "zora"],
	"screen_5_9": ["leever", "leever", "leever", "leever"],
	"screen_5_10": ["leever_blue", "leever_blue", "leever_blue", "leever_blue", "leever_blue", "leever_blue"],
	"screen_5_11": ["peahat", "peahat", "peahat", "leever", "leever_blue", "leever_blue"],
	"screen_5_12": ["tektite", "tektite", "tektite", "tektite"],
	"screen_5_13": ["octorock", "octorock", "octorock_blue", "octorock_blue", "zora"],
	"screen_5_14": ["octorock_blue", "octorock_blue", "octorock_blue", "octorock_blue", "zora"],
	"screen_5_15": [],
	"screen_6_0": ["lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue"],
	"screen_6_1": ["peahat", "peahat", "lynel", "lynel", "lynel_blue", "lynel_blue"],
	"screen_6_2": ["lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue"],
	"screen_6_3": ["lynel", "lynel", "lynel_blue", "lynel_blue"],
	"screen_6_4": ["lynel", "lynel", "lynel", "lynel"],
	"screen_6_5": ["peahat", "peahat", "lynel", "lynel", "lynel_blue", "lynel_blue"],
	"screen_6_6": ["rock_slide_area"],
	"screen_6_7": ["rock_slide_area", "zora"],
	"screen_6_8": ["rock_slide_area"],
	"screen_6_9": ["rock_slide_area"],
	"screen_6_10": ["tektite", "tektite", "tektite", "tektite", "tektite", "tektite", "zora"],
	"screen_6_11": [],
	"screen_6_12": [],
	"screen_6_13": ["peahat", "peahat", "peahat", "peahat", "peahat", "zora"],
	"screen_6_14": ["tektite", "tektite", "tektite", "tektite", "tektite", "tektite"],
	"screen_6_15": ["peahat", "peahat", "peahat", "peahat", "peahat", "peahat"],
	"screen_7_0": [],
	"screen_7_1": ["lynel", "lynel", "lynel", "lynel"],
	"screen_7_2": ["lynel", "lynel", "lynel", "lynel"],
	"screen_7_3": ["rock_slide_area"],
	"screen_7_4": ["lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue", "lynel_blue"],
	"screen_7_5": ["leever", "leever_blue", "lynel","lynel", "lynel_blue", "lynel_blue"],
	"screen_7_6": ["peahat", "peahat", "lynel","lynel", "lynel_blue", "lynel_blue"],
	"screen_7_7": ["lynel"],
	"screen_7_8": ["rock_slide_area"],
	"screen_7_9": [],
	"screen_7_10": ["lynel_blue", "zora"],
	"screen_7_11": ["leever"],
	"screen_7_12": ["tektite", "tektite", "tektite", "tektite", "tektite", "tektite"],
	"screen_7_13": ["tektite", "tektite", "tektite", "tektite", "tektite", "tektite"],
	"screen_7_14": [],
	"screen_7_15": []
};

var overworld_enemies_map = {};

var dungeon_enemy_pool = ["darknut", "darknut_blue", "gel", "gibdo", "goriya", "goriya_blue", "keese", "lanmola", "lanmola_blue", "like_like", "moldorm_spawner", "pols_voice", "rope", "stalfos", "vire", "wizzrobe", "wizzrobe_blue", "zol"];

var default_dungeon_enemy_map = {
	Inventory.LEVELS.ONE: {
		"loadables_0_1": ["keese", "keese", "keese"],
		"loadables_0_3": ["stalfos", "stalfos", "stalfos", "stalfos", "stalfos"],
		"loadables_1_2": ["stalfos", "stalfos", "stalfos"],
		"loadables_2_1": ["keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_2_2": ["stalfos", "stalfos", "stalfos", "stalfos", "stalfos"],
		"loadables_2_3": ["keese", "keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_3_1": ["gel", "gel", "gel"],
		"loadables_3_2": ["gel", "gel", "gel", "gel", "gel"],
		"loadables_3_3": ["goriya", "goriya", "goriya"],
		"loadables_3_4": [],
		"loadables_4_2": ["stalfos", "stalfos", "stalfos"],
		"loadables_4_4": [],
		"loadables_5_2": ["goriya", "goriya", "goriya"],
		"loadables_bowroom": ["keese", "keese", "keese", "keese"],
	},
	Inventory.LEVELS.TWO: {
		"loadables_0_2": ["rope", "rope", "rope", "rope", "rope"],
		"loadables_1_0": ["rope", "rope", "rope", "rope", "rope", "rope"],
		"loadables_1_1": ["rope", "rope", "rope", "rope", "rope"],
		"loadables_1_2": ["rope", "rope", "rope"],
		"loadables_1_3": ["gel", "gel", "gel", "gel", "gel", "gel"],
		"loadables_2_2": ["goriya", "goriya", "goriya", "goriya", "goriya"],
		"loadables_2_3": ["gel", "gel", "gel", "gel", "gel"],
		"loadables_3_2": ["rope", "rope", "rope", "rope", "rope"],
		"loadables_3_3": ["goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_4_2": ["moldorm_spawner", "moldorm_spawner"],
		"loadables_4_3": ["keese", "keese", "keese", "keese"],
		"loadables_5_2": ["rope", "rope", "rope", "rope", "rope", "rope", "rope"],
		"loadables_5_3": ["gel", "gel", "gel", "gel", "gel"],
		"loadables_6_2": ["goriya", "goriya", "goriya", "goriya", "goriya"]
	},
	Inventory.LEVELS.THREE: {
		"loadables_0_1": ["zol", "zol", "zol", "zol", "zol", "zol"],
		"loadables_1_0": ["darknut", "darknut", "darknut", "darknut", "darknut", "darknut", "darknut"],
		"loadables_1_2": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_2_0": ["darknut", "darknut", "darknut", "darknut", "darknut"],
		"loadables_2_1": ["keese", "keese", "keese", "keese"],
		"loadables_2_2": ["darknut", "darknut", "darknut"],
		"loadables_2_3": ["darknut", "darknut", "darknut"],
		"loadables_2_4": ["keese", "keese", "keese", "zol", "zol"],
		"loadables_3_0": ["keese", "keese", "keese", "zol", "zol"],
		"loadables_3_1": ["keese", "keese", "keese", "keese", "keese"],
		"loadables_3_2": ["zol", "zol", "zol"],
		"loadables_3_3": ["zol", "zol"],
		"loadables_4_2": ["zol", "zol"],
		"loadables_5_1": ["keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadablesraftroom": ["keese", "keese", "keese", "keese"]
	},
	Inventory.LEVELS.FOUR: {
		"loadables_0_0": ["keese", "keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_1_1": ["vire", "vire", "vire"],
		"loadables_1_2": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_2_0": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_2_1": ["keese", "keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_3_0": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_4_0": ["vire", "vire", "vire"],
		"loadables_4_1": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_4_2": ["zol", "zol", "like_like", "like_like"],
		"loadables_5_0": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_5_1": ["gel", "gel", "gel", "gel", "gel"],
		"loadables_6_2": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_7_1": ["keese", "keese", "keese", "keese", "keese", "keese"],
		"loadablesstepladder": ["keese", "keese", "keese", "keese"]
	},
	Inventory.LEVELS.FIVE: {
		"loadables_0_3": ["pols_voice", "pols_voice", "pols_voice", "pols_voice", "pols_voice"],
		"loadables_1_0": ["darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue"],
		"loadables_1_1": ["gibdo", "gibdo", "gibdo", "gibdo", "gibdo"],
		"loadables_1_2": ["gibdo", "gibdo", "gibdo"],
		"loadables_2_1": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_2_3": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_3_3": ["gibdo", "gibdo", "gibdo", "gibdo", "gibdo"],
		"loadables_4_0": ["gibdo", "gibdo", "gibdo", "gibdo", "gibdo", "gibdo"],
		"loadables_4_3": ["darknut", "darknut", "darknut"],
		"loadables_5_1": ["pols_voice", "pols_voice", "pols_voice", "pols_voice", "pols_voice"],
		"loadables_5_2": ["gibdo", "gibdo", "gibdo", "gibdo", "gibdo"],
		"loadables_5_3": ["pols_voice", "pols_voice", "keese", "keese", "gibdo", "gibdo"],
		"loadables_6_2": ["keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_7_1": ["darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue"],
		"loadablesflute": ["keese", "keese", "keese", "keese"],
		"loadablestunnela": ["keese", "keese", "keese", "keese"]
	},
	Inventory.LEVELS.SIX: {
		"loadables_0_0": ["wizzrobe", "wizzrobe", "wizzrobe", "wizzrobe"],
		"loadables_0_2": ["wizzrobe", "wizzrobe"],
		"loadables_1_0": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_2_0": ["keese", "keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_4_0": ["wizzrobe_blue", "wizzrobe_blue", "like_like", "like_like", "like_like"],
		"loadables_4_1": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_4_2": ["wizzrobe", "wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "like_like", "like_like", "like_like"],
		"loadables_4_4": ["wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_5_0": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_5_1": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_5_4": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_5_5": ["vire", "vire", "vire"],
		"loadables_6_1": ["like_like", "like_like", "zol", "zol"],
		"loadables_6_2": ["wizzrobe", "wizzrobe"],
		"loadables_6_3": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "like_like", "like_like"],
		"loadables_6_5": ["like_like", "like_like", "zol", "zol"],
		"loadables_7_1": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_7_2": ["like_like", "like_like", "zol", "zol"],
		"loadablesmagicrod": ["keese", "keese", "keese", "keese"],
		"loadablestunnela": ["keese", "keese", "keese", "keese"]
	},
	Inventory.LEVELS.SEVEN: {
		"loadables_0_0": ["rope", "rope", "rope", "rope", "rope"],
		"loadables_0_2": ["moldorm_spawner", "moldorm_spawner"],
		"loadables_1_0": ["keese", "keese", "keese", "keese"],
		"loadables_1_1": ["goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_1_2": ["keese", "keese","keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_1_3": ["goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_1_5": ["stalfos", "stalfos", "stalfos", "stalfos", "stalfos", "stalfos", "stalfos"],
		"loadables_2_1": ["goriya", "goriya", "goriya", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_2_2": ["stalfos", "stalfos", "stalfos", "stalfos", "stalfos", "stalfos", "stalfos"],
		"loadables_3_1": ["goriya_blue", "goriya_blue", "goriya_blue", "keese", "keese"],
		"loadables_4_0": ["goriya", "goriya", "goriya", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_4_2": ["moldorm_spawner", "moldorm_spawner"],
		"loadables_5_1": ["goriya", "goriya", "goriya", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_6_0": ["goriya_blue", "goriya_blue", "goriya_blue", "keese", "keese", "keese"],
		"loadables_6_1": ["goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_6_2": ["goriya", "goriya", "goriya", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_6_3": ["goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_7_1": ["goriya", "goriya", "goriya", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_7_2": ["goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue", "goriya_blue"],
		"loadables_7_3": ["moldorm_spawner", "moldorm_spawner"],
		"loadablesredcandle": ["keese", "keese", "keese", "keese"],
		"loadablestunnela": ["keese", "keese", "keese", "keese"],
	},
	Inventory.LEVELS.EIGHT: {
		"loadables_0_1": ["darknut", "darknut", "darknut_blue", "gibdo", "gibdo", "gibdo"],
		"loadables_0_4": ["keese", "keese", "keese", "zol", "zol"],
		"loadables_2_1": ["darknut", "darknut", "darknut"],
		"loadables_2_2": ["gibdo", "gibdo", "keese", "keese", "pols_voice", "pols_voice"],
		"loadables_2_3": ["darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue"],
		"loadables_2_4": ["pols_voice", "pols_voice", "pols_voice", "pols_voice", "pols_voice", "pols_voice", "pols_voice"],
		"loadables_3_0": ["darknut", "darknut", "darknut", "darknut", "darknut", "darknut"],
		"loadables_3_1": ["pols_voice", "pols_voice", "pols_voice", "pols_voice"],
		"loadables_3_3": ["darknut", "darknut", "darknut_blue", "gibdo", "gibdo", "gibdo"],
		"loadables_4_3": ["darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue", "darknut_blue"],
		"loadables_4_4": ["darknut", "darknut", "darknut_blue", "gibdo", "gibdo", "gibdo"],
		"loadables_6_2": ["pols_voice", "pols_voice", "pols_voice", "pols_voice", "pols_voice"],
		"loadables_6_4": ["darknut", "darknut", "darknut_blue", "darknut_blue", "pols_voice", "pols_voice"],
		"loadables_7_3": ["darknut", "darknut", "darknut", "darknut", "darknut"],
		"loadablesmagicbook": ["keese", "keese", "keese", "keese"],
		"loadablesmagickey": ["keese", "keese", "keese", "keese"],
		"loadablestunnela": ["keese", "keese", "keese", "keese"]
	},
	Inventory.LEVELS.NINE: {
		"loadables_0_3": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadabels_0_4": ["lanmola_blue", "lanmola_blue"],
		"loadables_1_2": ["keese", "keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_1_3": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_1_4": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "like_like", "like_like", "like_like"],
		"loadables_1_5": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_2_0": ["zol", "zol", "zol", "zol", "zol"],
		"loadables_2_1": ["like_like", "like_like", "like_like", "like_like", "like_like", "like_like"],
		"loadables_2_3": ["like_like", "like_like", "like_like", "wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],	
		"loadables_2_4": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_2_5": ["lanmola","lanmola"],
		"loadables_2_6": ["like_like", "like_like", "zol", "zol"],
		"loadables_2_7": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_3_0": ["wizzrobe","wizzrobe_blue", "wizzrobe_blue"],
		"loadables_3_1": ["like_like", "like_like", "like_like", "like_like"],
		"loadables_3_4": ["wizzrobe", "wizzrobe", "wizzrobe", "wizzrobe"],
		"loadables_3_5": ["like_like", "like_like", "like_like", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_3_6": ["wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_3_7": ["wizzrobe","wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_4_0": ["wizzrobe","wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_4_1": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "like_like", "like_like", "like_like"],
		"loadables_4_3": ["gel", "gel", "gel", "gel", "gel", "gel", "gel"],
		"loadables_4_4": ["keese", "keese", "keese", "keese", "keese", "keese", "keese"],
		"loadables_4_5": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_4_6": ["zol", "zol", "keese", "keese", "keese"],
		"loadables_4_7": ["vire", "vire", "vire", "vire", "vire", "vire"],
		"loadables_5_0": ["wizzrobe","wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_5_2": ["zol", "zol", "like_like", "like_like"],
		"loadables_5_3": ["gel", "gel", "gel", "gel"],
		"loadables_5_4": ["vire", "vire", "vire", "vire", "vire"],
		"loadables_5_5": ["like_like", "like_like", "zol", "zol"],
		"loadables_5_6": ["gel", "gel", "gel", "gel", "gel", "gel", "gel", "gel"],
		"loadables_6_0": ["wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_6_1": ["lanmola_blue", "lanmola_blue"],
		"loadables_6_2": ["lanmola", "lanmola"],
		"loadables_6_3": ["like_like", "like_like", "zol", "zol"],
		"loadables_6_4": ["like_like", "like_like"],
		"loadables_6_5": ["wizzrobe_blue", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_6_7": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue", "like_like", "like_like", "like_like"],
		"loadables_7_1": ["zol", "zol", "keese", "keese", "keese"],
		"loadables_7_3": ["zol", "zol", "like_like", "like_like"],
		"loadables_7_4": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],
		"loadables_7_5": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue","wizzrobe_blue"],
		"loadables_7_7": ["wizzrobe", "wizzrobe", "wizzrobe_blue", "wizzrobe_blue"],
		"loadablesredring": ["keese", "keese", "keese", "keese"],
		"loadablessilverarrow": ["keese", "keese", "keese", "keese"],
		"loadablestunnela": ["keese", "keese", "keese", "keese"],
		"loadablestunnelb": ["keese", "keese", "keese", "keese"],
		"loadablestunnelc": ["keese", "keese", "keese", "keese"],
		"loadablestunneld": ["keese", "keese", "keese", "keese"],
		"loadablestunnele": ["keese", "keese", "keese", "keese"],
		"loadablestunnelf": ["keese", "keese", "keese", "keese"],
	}
};

var dungeon_enemy_map = {};

var default_item_map = {
	"overworld/under_armos": "item/power_bracelet/"+str(Inventory.ITEM_TYPES.LVL1),
	"overworld/east_shore_dock": "counter/heart_containers/1",
	
	"cave/secret_cave_30/0": "counter/rupees/30",
	"cave/wooden_sword_cave/item_1": "item/sword/"+str(Inventory.ITEM_TYPES.LVL1),
	"cave/wooden_sword_cave/item_2": "sword_scroll/"+str(Inventory.SWORD_SCROLLS.GREAT_SPIN_ATTACK),
	"cave/sword_scroll_cave/0": "sword_scroll/"+str(Inventory.SWORD_SCROLLS.ROLL_ATTACK),
	"cave/potion_or_heart_container_cave/0": "counter/heart_containers/1",
	"cave/secret_cave_100/0": "counter/rupees/100",
	"cave/secret_cave_30/1": "counter/rupees/30",
	"cave/secret_cave_100/1": "counter/rupees/100",	
	"cave/secret_cave_10/0": "counter/rupees/10", 
	"cave/secret_cave_10/1": "counter/rupees/10",
	"cave/secret_cave_10/2": "counter/rupees/10",
	"cave/potion_or_heart_container_cave/1": "counter/heart_containers/1",
	"cave/secret_cave_30/2": "counter/rupees/30",
	"cave/secret_cave_10/3": "counter/rupees/10",
	"cave/sword_scroll_cave/1": "sword_scroll/"+str(Inventory.SWORD_SCROLLS.RISING_SPIN_ATTACK),
	"cave/secret_cave_30/3": "counter/rupees/30",
	"cave/magic_sword_cave/item_1": "item/sword/"+str(Inventory.ITEM_TYPES.LVL3),
	"cave/magic_sword_cave/item_2": "sword_scroll/"+str(Inventory.SWORD_SCROLLS.SHIELD_STAB),
	"cave/secret_cave_30/4": "counter/rupees/30",
	"cave/potion_or_heart_container_cave/2": "counter/heart_containers/1",
	"cave/secret_cave_30/5": "counter/rupees/30",
	"cave/potion_or_heart_container_cave/3": "counter/heart_containers/1",
	"cave/sword_scroll_cave/2": "sword_scroll/"+str(Inventory.SWORD_SCROLLS.JUMP_OVER_ATTACK),
	"cave/secret_cave_30/6": "counter/rupees/30",
	"cave/white_sword_cave/item_1": "item/sword/"+str(Inventory.ITEM_TYPES.LVL2),
	"cave/white_sword_cave/item_2": "sword_scroll/"+str(Inventory.SWORD_SCROLLS.BACK_FLIP_ATTACK),
	"cave/letter_cave": "item/letter/"+str(Inventory.ITEM_TYPES.LVL1),
	"cave/secret_cave_100/2": "counter/rupees/100",

	"shop_1/item_3": "item/candle/"+str(Inventory.ITEM_TYPES.LVL1),
	"shop_2/item_3": "item/arrow/"+str(Inventory.ITEM_TYPES.LVL1),
	"shop_4/item_2": "item/ring/"+str(Inventory.ITEM_TYPES.LVL1),
	
	"dungeon/1/loadables_bowroom": "item/bow/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/1/loadables_5_2": "counter/keys/1/1",
	"dungeon/1/loadables_4_4": "counter/heart_containers/1",
	"dungeon/1/loadables_4_2": "counter/keys/1/2",
	"dungeon/1/loadables_3_4": "counter/keys/1/3",
	"dungeon/1/loadables_3_3": "item/boomerang/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/1/loadables_3_2": "map/1",
	"dungeon/1/loadables_2_3": "compass/1",
	"dungeon/1/loadables_2_2": "counter/keys/1/4",
	"dungeon/1/loadables_0_3": "counter/keys/1/5",
	"dungeon/1/loadables_0_1": "counter/keys/1/6",
	"dungeon/2/loadables_7_2": "counter/heart_containers/1",
	"dungeon/2/loadables_6_2": "counter/bombs/4",
	"dungeon/2/loadables_5_3": "counter/rupees/5",
	"dungeon/2/loadables_4_3": "counter/bombs/4",
	"dungeon/2/loadables_4_2": "counter/keys/1/7",
	"dungeon/2/loadables_3_3": "item/boomerang/"+str(Inventory.ITEM_TYPES.LVL2),
	"dungeon/2/loadables_3_2": "counter/keys/1/8",
	"dungeon/2/loadables_2_3": "map/2",
	"dungeon/2/loadables_1_3": "compass/2",
	"dungeon/2/loadables_1_0": "counter/keys/1/9",
	"dungeon/2/loadables_0_2": "counter/keys/1/10",
	"dungeon/3/loadablesraftroom": "item/raft/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/3/loadables_5_1": "counter/keys/1/11",
	"dungeon/3/loadables_3_4": "counter/heart_containers/1",
	"dungeon/3/loadables_3_3": "map/3",
	"dungeon/3/loadables_3_2": "counter/keys/1/12",
	"dungeon/3/loadables_3_1": "counter/bombs/4",
	"dungeon/3/loadables_3_0": "counter/keys/1/13",
	"dungeon/3/loadables_2_2": "counter/bombs/4",
	"dungeon/3/loadables_2_1": "compass/3",
	"dungeon/3/loadables_1_2": "counter/keys/1/14",
	"dungeon/3/loadables_0_2": "counter/keys/1/15",
	"dungeon/4/loadablesstepladder": "item/step_ladder/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/4/loadables_7_1": "counter/keys/1/16",
	"dungeon/4/loadables_6_3": "counter/heart_containers/1",
	"dungeon/4/loadables_5_1": "map/4",
	"dungeon/4/loadables_3_0": "counter/keys/1/17",
	"dungeon/4/loadables_2_1": "counter/keys/1/18",
	"dungeon/4/loadables_1_2": "compass/4",
	"dungeon/4/loadables_0_0": "counter/keys/1/19",
	"dungeon/5/loadablesflute": "item/recorder/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/5/loadables_6_3": "counter_max/bombs/4",
	"dungeon/5/loadables_6_2": "counter/keys/1/20",
	"dungeon/5/loadables_5_3": "counter/keys/1/21",
	"dungeon/5/loadables_5_2": "counter/keys/1/22",
	"dungeon/5/loadables_5_0": "counter/heart_containers/1",
	"dungeon/5/loadables_4_3": "compass/5",
	"dungeon/5/loadables_3_3": "counter/keys/1/23",
	"dungeon/5/loadables_3_2": "map/5",
	"dungeon/5/loadables_2_3": "counter/rupees/5",
	"dungeon/5/loadables_2_2": "counter/bombs/4",
	"dungeon/5/loadables_2_1": "counter/keys/1/24",
	"dungeon/5/loadables_1_2": "counter/keys/1/25",
	"dungeon/5/loadables_1_1": "counter/bombs/4",
	"dungeon/5/loadables_0_3": "counter/keys/1/26",
	"dungeon/6/loadablesmagicrod": "item/magic_rod/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/6/loadables_6_4": "counter/heart_containers/1",
	"dungeon/6/loadables_6_2": "counter/keys/1/27",
	"dungeon/6/loadables_6_1": "map/6",
	"dungeon/6/loadables_5_5": "counter/keys/1/28",
	"dungeon/6/loadables_5_1": "counter/keys/1/29",
	"dungeon/6/loadables_2_0": "counter/keys/1/30",
	"dungeon/6/loadables_1_0": "compass/6",
	"dungeon/6/loadables_0_2": "counter/keys/1/31",
	"dungeon/7/loadablesredcandle": "item/candle/"+str(Inventory.ITEM_TYPES.LVL2),
	"dungeon/7/loadables_7_4": "counter/bombs/4",
	"dungeon/7/loadables_7_3": "counter/bombs/4",
	"dungeon/7/loadables_7_2": "counter/keys/1/32",
	"dungeon/7/loadables_7_1": "counter/rupees/5",
	"dungeon/7/loadables_6_3": "counter/bombs/4",
	"dungeon/7/loadables_6_0": "map/7",
	"dungeon/7/loadables_5_2": "counter/heart_containers/1",
	"dungeon/7/loadables_4_2": "counter/keys/1/33",
	"dungeon/7/loadables_4_0": "counter/rupees/5",
	"dungeon/7/loadables_3_0": "counter_max/bombs/4",
	"dungeon/7/loadables_2_2": "compass/7",
	"dungeon/7/loadables_2_0": "counter/rupees/5",
	"dungeon/7/loadables_1_5": "counter/keys/1/34",
	"dungeon/7/loadables_1_4": "counter/bombs/4",
	"dungeon/7/loadables_1_1": "counter/bombs/4",
	"dungeon/7/loadables_1_0": "counter/bombs/4",
	"dungeon/7/loadables_0_2": "counter/bombs/4",
	"dungeon/7/loadables_0_0": "counter/keys/1/35",
	"dungeon/8/loadablesmagickey": "item/magic_key/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/8/loadablesmagicbook": "item/book_of_magic/"+str(Inventory.ITEM_TYPES.LVL1),
	"dungeon/8/loadables_7_3": "counter/bombs/4",
	"dungeon/8/loadables_6_2": "counter/bombs/4",
	"dungeon/8/loadables_5_3": "map/8",
	"dungeon/8/loadables_4_4": "counter/bombs/4",
	"dungeon/8/loadables_4_1": "counter/heart_containers/1",
	"dungeon/8/loadables_3_3": "counter/rupees/5",
	"dungeon/8/loadables_3_1": "counter/keys/1/36",
	"dungeon/8/loadables_3_0": "counter/keys/1/37",
	"dungeon/8/loadables_2_4": "compass/8",
	"dungeon/8/loadables_2_3": "counter/keys/1/38",
	"dungeon/8/loadables_2_2": "counter/keys/1/39",
	"dungeon/8/loadables_2_1": "counter/keys/1/40",
	"dungeon/8/loadables_1_3": "counter/rupees/5",
	"dungeon/8/loadables_0_4": "counter/keys/1/41",
	"dungeon/8/loadables_0_2": "counter/rupees/5",
	"dungeon/9/loadablessilverarrow": "item/arrow/"+str(Inventory.ITEM_TYPES.LVL2),
	"dungeon/9/loadablesredring": "item/ring/"+str(Inventory.ITEM_TYPES.LVL2),
	"dungeon/9/loadables_6_6": "counter/bombs/4",
	"dungeon/9/loadables_6_5": "counter/rupees/5",
	"dungeon/9/loadables_6_2": "counter/rupees/5",
	"dungeon/9/loadables_6_1": "counter/bombs/4",
	"dungeon/9/loadables_5_7": "map/9",
	"dungeon/9/loadables_5_6": "counter/rupees/5",
	"dungeon/9/loadables_5_5": "counter/bombs/4",
	"dungeon/9/loadables_5_3": "counter/bombs/4",
	"dungeon/9/loadables_4_7": "counter/bombs/4",
	"dungeon/9/loadables_4_5": "compass/9",
	"dungeon/9/loadables_4_4": "counter/rupees/5",
	"dungeon/9/loadables_3_7": "counter/keys/1/42",
	"dungeon/9/loadables_3_4": "counter/rupees/5",
	"dungeon/9/loadables_3_0": "counter/rupees/5",
	"dungeon/9/loadables_2_7": "counter/keys/1/43",
	"dungeon/9/loadables_2_6": "counter/keys/1/44",
	"dungeon/9/loadables_1_2": "counter/rupees/5",
	"dungeon/9/loadables_1_1": "counter/keys/1/45"
};

var item_map = {};

var default_shop_map = {
	"potion_shop/item_1": "item/potion/"+str(Inventory.ITEM_TYPES.LVL1),
	"potion_shop/item_2": "item/potion/"+str(Inventory.ITEM_TYPES.LVL2),
	"shop_1/item_1": "item/shield/"+str(Inventory.ITEM_TYPES.LVL2),
	"shop_1/item_2": "counter/keys/1",
	"shop_2/item_1": "item/shield/"+str(Inventory.ITEM_TYPES.LVL2),
	"shop_2/item_2": "counter/bombs/4",
	"shop_3/item_1": "item/shield/"+str(Inventory.ITEM_TYPES.LVL2),
	"shop_3/item_2": "counter/food/10",
	"shop_3/item_3": "heart/heart/1",
	"shop_4/item_1": "counter/keys/1",
	"shop_4/item_3": "counter/food/10"
};

var shop_map = {};

var location_gates = {
	# Dungeons
	"entrance_1": "",
	"entrance_2": "",
	"entrance_3": "",
	"entrance_4": "raft",
	"entrance_5": "",
	"entrance_6": "",
	"entrance_7": "flute",
	"entrance_8": "candle",
	"entrance_9": "bombs",
	# Caves
	"screen_0_0": "",
	"screen_0_1": "bombs",
	"screen_0_5": "",
	"screen_0_6": "bombs",
	"screen_0_7": "",
	"screen_0_8": "candle",
	"screen_0_9": "power_bracelet",
	"screen_0_10": "bombs",
	"screen_0_11": "bombs",
	"screen_0_12": "bombs",
	"screen_0_13": "bombs",
	"screen_1_2": "candle",
	"screen_1_3": "candle",
	"screen_1_4": "",
	"screen_1_6": "",
	"screen_1_7": "bombs",
	"screen_1_8": "candle",
	"screen_1_10": "candle",
	"screen_1_11": "candle",
	"screen_1_15": "",
	"screen_2_1": "candle",
	"screen_2_6": "candle",
	"screen_2_11": "candle",
	"screen_2_14": "",
	"screen_3_4": "",
	"screen_3_6": "candle",
	"screen_3_7": "candle",
	"screen_3_8": "candle",
	"screen_3_9": "power_bracelet",
	"screen_3_10": "",
	"screen_3_11": "candle",
	"screen_3_13": "candle",
	"screen_3_14": "",
	"screen_3_15": "bombs",
	"screen_4_3": "bombs",
	"screen_4_4": "",
	"screen_4_13": "",
	"screen_5_1": "",
	"screen_5_3": "power_bracelet",
	"screen_5_5": "",
	"screen_5_6": "bombs",
	"screen_5_7": "bombs",
	"screen_5_8": "candle",
	"screen_5_12": "bombs",
	"screen_5_13": "bombs",
	"screen_5_15": "raft",
	"screen_6_0": "bombs",
	"screen_6_1": "bombs",
	"screen_6_2": "bombs",
	"screen_6_3": "bombs",
	"screen_6_4": "bombs",
	"screen_6_6": "bombs",
	"screen_6_10": "step_ladder",
	"screen_6_12": "",
	"screen_6_13": "power_bracelet",
	"screen_6_14": "bombs",
	"screen_6_15": "",
	"screen_7_1": "bombs",
	"screen_7_3": "bombs",
	"screen_7_4": "",
	"screen_7_7": "bombs",
	"screen_7_10": "",
	"screen_7_12": "",
	"screen_7_13": "bombs",
	"screen_7_14": "",
	"screen_7_15": "",
	# Overworld Items
	"overworld/under_armos": "",
	"overworld/east_shore_dock": "step_ladder",
	# Cave Items
	"cave/secret_cave_30/0": "",
	"cave/wooden_sword_cave/item_1": "",
	"cave/wooden_sword_cave/item_2": "hearts_4",
	"cave/sword_scroll_cave/0": "",
	"cave/potion_or_heart_container_cave/0": "",
	"cave/secret_cave_100/0": "",
	"cave/secret_cave_30/1": "",
	"cave/secret_cave_100/1": "",	
	"cave/secret_cave_10/0": "", 
	"cave/secret_cave_10/1": "",
	"cave/secret_cave_10/2": "",
	"cave/potion_or_heart_container_cave/1": "",
	"cave/secret_cave_30/2": "",
	"cave/secret_cave_10/3": "",
	"cave/sword_scroll_cave/1": "",
	"cave/secret_cave_30/3": "",
	"cave/magic_sword_cave/item_1": "hearts_12",
	"cave/magic_sword_cave/item_2": "hearts_16",
	"cave/secret_cave_30/4": "",
	"cave/potion_or_heart_container_cave/2": "",
	"cave/secret_cave_30/5": "",
	"cave/potion_or_heart_container_cave/3": "",
	"cave/sword_scroll_cave/2": "",
	"cave/secret_cave_30/6": "",
	"cave/white_sword_cave/item_1": "hearts_5",
	"cave/white_sword_cave/item_2": "hearts_10",
	"cave/letter_cave": "",
	"cave/secret_cave_100/2": "",
	# Shop Items
	"shop_1/item_3": "sword",
	"shop_2/item_3": "sword",
	"shop_4/item_2": "sword",
	"potion_shop/item_1": "letter/sword",
	"potion_shop/item_2": "letter/sword",
	"shop_1/item_1": "sword",
	"shop_1/item_2": "sword",
	"shop_2/item_1": "sword",
	"shop_2/item_2": "sword",
	"shop_3/item_1": "sword",
	"shop_3/item_2": "sword",
	"shop_3/item_3": "sword",
	"shop_4/item_1": "sword",
	"shop_4/item_3": "sword",
	# Dungeon Items
	"dungeon/1/loadables_bowroom": "key_1/key_2/key_5/key_6",
	"dungeon/1/loadables_5_2": "sword/key_1/key_2/key_5",
	"dungeon/1/loadables_4_4": "sword/key_1/key_2/key_3/key_4",
	"dungeon/1/loadables_4_2": "sword/key_1/key_2",
	"dungeon/1/loadables_3_4": "key_1/key_2/key_3",
	"dungeon/1/loadables_3_3": "sword/key_1/key_2/key_3",
	"dungeon/1/loadables_3_2": "sword/key_1/key_2",
	"dungeon/1/loadables_2_3": "sword/key_1",
	"dungeon/1/loadables_2_2": "sword/key_1",
	"dungeon/1/loadables_0_3": "sword",
	"dungeon/1/loadables_0_1": "sword",
	"dungeon/2/loadables_7_2": "sword",
	"dungeon/2/loadables_6_2": "sword",
	"dungeon/2/loadables_5_3": "sword/key_9",
	"dungeon/2/loadables_4_3": "sword",
	"dungeon/2/loadables_4_2": "sword",
	"dungeon/2/loadables_3_3": "sword",
	"dungeon/2/loadables_3_2": "sword",
	"dungeon/2/loadables_2_3": "sword/key_8",
	"dungeon/2/loadables_1_3": "sword/key_7",
	"dungeon/2/loadables_1_0": "sword",
	"dungeon/2/loadables_0_2": "sword",
	"dungeon/3/loadablesraftroom": "sword/key_10",
	"dungeon/3/loadables_5_1": "sword/key_13",
	"dungeon/3/loadables_3_4": "sword/key_12",
	"dungeon/3/loadables_3_3": "sword/key_12",
	"dungeon/3/loadables_3_2": "sword",
	"dungeon/3/loadables_3_1": "sword/key_11",
	"dungeon/3/loadables_3_0": "sword/key_10",
	"dungeon/3/loadables_2_2": "sword",
	"dungeon/3/loadables_2_1": "sword",
	"dungeon/3/loadables_1_2": "sword",
	"dungeon/3/loadables_0_2": "sword",
	"dungeon/4/loadablesstepladder": "sword/candle/key_15",
	"dungeon/4/loadables_7_1": "sword/candle/step_ladder/key_16/key_18",
	"dungeon/4/loadables_6_3": "sword/candle/step_ladder/key_16/key_18",
	"dungeon/4/loadables_5_1": "sword/candle/step_ladder/key_16",
	"dungeon/4/loadables_3_0": "sword/candle",
	"dungeon/4/loadables_2_1": "sword",
	"dungeon/4/loadables_1_2": "sword/candle/key_14",
	"dungeon/4/loadables_0_0": "sword",
	"dungeon/5/loadablesflute": "sword/candle/step_ladder/bombs/key_24",
	"dungeon/5/loadables_6_3": "sword/candle/step_ladder/bombs/key_23",
	"dungeon/5/loadables_6_2": "sword/candle/step_ladder/bombs/key_23",
	"dungeon/5/loadables_5_3": "sword/candle/step_ladder",
	"dungeon/5/loadables_5_2": "sword/candle/step_ladder/key_21",
	"dungeon/5/loadables_5_0": "sword/candle/step_ladder/flute/key_21/key_22",
	"dungeon/5/loadables_4_3": "sword/candle/step_ladder",
	"dungeon/5/loadables_3_3": "sword/candle/step_ladder",
	"dungeon/5/loadables_3_2": "sword/candle/step_ladder/key_20",
	"dungeon/5/loadables_2_3": "sword/candle/step_ladder",
	"dungeon/5/loadables_2_2": "sword/candle/step_ladder",
	"dungeon/5/loadables_2_1": "sword/candle/step_ladder",
	"dungeon/5/loadables_1_2": "sword/candle/step_ladder",
	"dungeon/5/loadables_1_1": "sword/candle/step_ladder",
	"dungeon/5/loadables_0_3": "sword",
	"dungeon/6/loadablesmagicrod": "sword/candle/key_25/key_28",
	"dungeon/6/loadables_6_4": "sword/candle/step_ladder/key_25/key_27/key_29",
	"dungeon/6/loadables_6_2": "sword/candle/step_ladder/key_25",
	"dungeon/6/loadables_6_1": "sword/candle/step_ladder/key_25",
	"dungeon/6/loadables_5_5": "sword/candle/step_ladder/key_25/key_27",
	"dungeon/6/loadables_5_1": "sword/candle/key_25/key_27",
	"dungeon/6/loadables_2_0": "sword/key_25",
	"dungeon/6/loadables_1_0": "sword/key_25",
	"dungeon/6/loadables_0_2": "sword/candle",
	"dungeon/7/loadablesredcandle": "sword/bombs/food/step_ladder/candle/key_31",
	"dungeon/7/loadables_7_4": "sword/bombs/food/step_ladder/candle/key_31/key_33/flute",
	"dungeon/7/loadables_7_3": "sword/bombs/food/step_ladder/candle/key_31/key_32",
	"dungeon/7/loadables_7_2": "sword/bombs/food/step_ladder/candle/key_31",
	"dungeon/7/loadables_7_1": "sword/bombs/food/step_ladder/candle/key_31",
	"dungeon/7/loadables_6_3": "sword/bombs/food/step_ladder/candle/key_31",
	"dungeon/7/loadables_6_0": "sword/bombs/food/step_ladder/candle",
	"dungeon/7/loadables_5_2": "sword/bombs/food/step_ladder/candle/key_31/key_33/flute",
	"dungeon/7/loadables_4_2": "sword/bombs/step_ladder",
	"dungeon/7/loadables_4_0": "sword/bombs/step_ladder",
	"dungeon/7/loadables_3_0": "bombs/key_30",
	"dungeon/7/loadables_2_2": "sword/bombs/step_ladder",
	"dungeon/7/loadables_2_0": "sword/bombs",
	"dungeon/7/loadables_1_5": "sword/candle/step_ladder",
	"dungeon/7/loadables_1_4": "sword/candle/flute",
	"dungeon/7/loadables_1_1": "sword",
	"dungeon/7/loadables_1_0": "sword/bombs",
	"dungeon/7/loadables_0_2": "sword",
	"dungeon/7/loadables_0_0": "sword/bombs",
	"dungeon/8/loadablesmagickey": "sword/bombs/key_36/key_37/bow/arrow",
	"dungeon/8/loadablesmagicbook": "sword",
	"dungeon/8/loadables_7_3": "sword/bombs/key_36/key_37/bow/arrow",
	"dungeon/8/loadables_6_2": "sword/bombs/key_36/key_37",
	"dungeon/8/loadables_5_3": "sword/bombs/key_36",
	"dungeon/8/loadables_4_4": "sword/bombs/key_36",
	"dungeon/8/loadables_4_1": "sword/bombs/key_36",
	"dungeon/8/loadables_3_3": "sword/bombs",
	"dungeon/8/loadables_3_1": "sword/bombs/key_36",
	"dungeon/8/loadables_3_0": "sword/bombs/key_36/candle",
	"dungeon/8/loadables_2_4": "sword/bombs/candle/key_34",
	"dungeon/8/loadables_2_3": "sword/bombs",
	"dungeon/8/loadables_2_2": "sword/bombs/candle",
	"dungeon/8/loadables_2_1": "sword/bombs/candle",
	"dungeon/8/loadables_1_3": "sword",
	"dungeon/8/loadables_0_4": "sword/candle/step_ladder",
	"dungeon/8/loadables_0_2": "sword",
	"dungeon/9/loadablessilverarrow": "triforce/sword/bombs/candle/key_38/key_39",
	"dungeon/9/loadablesredring": "triforce/sword/bombs/candle/key_38",
	"dungeon/9/loadables_6_6": "triforce/sword/bombs/candle/key_38",
	"dungeon/9/loadables_6_5": "triforce/sword/candle/step_ladder/bombs/key_38",
	"dungeon/9/loadables_6_2": "triforce/sword/bombs/candle/key_38/key_39/key_42",
	"dungeon/9/loadables_6_1": "triforce/sword/bombs/candle/key_38/key_39",
	"dungeon/9/loadables_5_7": "triforce/sword/bombs/candle/key_38",
	"dungeon/9/loadables_5_6": "triforce/sword/bombs/candle/key_38",
	"dungeon/9/loadables_5_5": "triforce/sword/bombs/key_38/candle",
	"dungeon/9/loadables_5_3": "triforce/sword/candle/bombs",
	"dungeon/9/loadables_4_7": "triforce/sword/bombs/candle/key_38",
	"dungeon/9/loadables_4_5": "triforce/sword/bombs/key_38/candle",
	"dungeon/9/loadables_4_4": "triforce/sword/step_ladder/candle/bombs",
	"dungeon/9/loadables_3_7": "triforce/sword/bombs/candle/key_38",
	"dungeon/9/loadables_3_4": "triforce/sword/step_ladder",
	"dungeon/9/loadables_3_0": "triforce/sword/bombs/candle/key_38/key_39/key_40",
	"dungeon/9/loadables_2_7": "triforce/sword/bombs",
	"dungeon/9/loadables_2_6": "triforce/sword/step_ladder",
	"dungeon/9/loadables_1_2": "triforce/sword/bombs/candle/key_38/key_39",
	"dungeon/9/loadables_1_1": "triforce/sword/bombs/candle/key_38/key_39"
};

const TRIFORCE_KEYS = [
	"sword", 
	"bombs", 
	"candle", 
	"bow", 
	"arrow", 
	"flute", 
	"raft",
	"step_ladder",
	"key_1",
	"key_2",
	"key_3",
	"key_4",
	"key_5",
	"key_6",
	"key_7",
	"key_8",
	"key_9",
	"key_10",
	"key_11",
	"key_12",
	"key_13",
	"key_14",
	"key_15",
	"key_16",
	"key_17",
	"key_18",
	"key_19",
	"key_20",
	"key_21",
	"key_22",
	"key_23",
	"key_24",
	"key_25",
	"key_26",
	"key_27",
	"key_28",
	"key_29",
	"key_30",
	"key_31",
	"key_32",
	"key_33",
	"key_34",
	"key_35",
	"key_36",
	"key_37",
];

func load_data(slot: String):
	if not FileAccess.file_exists("user://"+slot+"/randomizer.save"):
		unrandomize();
		return;
	
	var file = FileAccess.open("user://"+slot+"/randomizer.save", FileAccess.READ);
	var data_string = file.get_line();
	var data = JSON.parse_string(data_string);
	randomizer_seed = data.seed;
	randomize_wood_sword = data.wood_sword;
	if data.has("caves"): do_random_caves = data.caves;
	if data.has("dungeons"): do_random_dungeon_locations = data.dungeons;
	if data.has("enemies"): do_random_enemies = data.enemies;
	if data.has("shops"): do_random_shops = data.shops;
	if data.has("item_randomization"): 
		item_randomization = int(data.item_randomization) as ITEM_RANDOMIZATIONS;
	generate();

func unrandomize():
	caves_map = default_caves_map.duplicate_deep();
	dungeons_map = default_dungeons_map.duplicate_deep();
	overworld_enemies_map = default_overworld_enemies_map.duplicate_deep();
	dungeon_enemy_map = default_dungeon_enemy_map.duplicate_deep();
	item_map = default_item_map.duplicate_deep();
	shop_map = default_shop_map.duplicate_deep();

const VALID_SEED_CHARS: String = "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVxXyYzZ0123456789";
const SEED_LENGTH = 16;
func generate_random_seed():
	randomizer_seed = "";
	for i in range(SEED_LENGTH):
		randomizer_seed += VALID_SEED_CHARS[randi_range(0, len(VALID_SEED_CHARS)-1)];

func apply_seed():
	random.seed = randomizer_seed.hash();

func generate():
	unrandomize();

	apply_seed();
	
	# Randomize Caves
	if do_random_caves:
		randomize_caves();
	# Randomize Dungeon Locations
	if do_random_dungeon_locations:
		randomize_dungeons();
	# Randomize Enemies
	if do_random_enemies:
		randomize_enemies();
	# Randomize Shops
	if do_random_shops:
		randomize_shops();
	# Randomize Items
	randomize_items();

func randomize_caves():
	var map: Dictionary = default_caves_map.duplicate_deep();
	if not randomize_wood_sword:
		map.erase("screen_0_7");
		caves_map["screen_0_7"] = "wooden_sword_cave";
	
	var screen_list: Array = map.keys();
	var cave_list: Array = map.values();
	
	# Need to erase again because screen_0_7 and wooden_sword_cave are somehow at the end of these arrays
	if not randomize_wood_sword and "screen_0_7" in screen_list:
		screen_list.erase("screen_0_7");
	if not randomize_wood_sword and "wooden_sword_cave" in cave_list:
		cave_list.erase("wooden_sword_cave");
	
	for screen in screen_list:
		caves_map[screen] = cave_list.pop_at(random.randi_range(0, len(cave_list)-1));

func randomize_dungeons():
	var entrance_list: Array = default_dungeons_map.keys();
	var dungeon_list: Array = default_dungeons_map.values();
	
	for entrance in entrance_list:
		dungeons_map[entrance] = dungeon_list.pop_at(random.randi_range(0, len(dungeon_list)-1));

func randomize_enemies():
	# Overworld Enemies
	for screen in default_overworld_enemies_map:
		var enemies = [];
		for enemy in default_overworld_enemies_map[screen]:
			if enemy in static_enemy_pool:
				enemies.push_back(enemy);
			else:
				enemies.push_back(overworld_enemy_pool[random.randi_range(0, len(overworld_enemy_pool)-1)]);
		overworld_enemies_map[screen] = enemies;
	
	#Dungeon Enemies
	for dungeon in default_dungeon_enemy_map:
		var dungeon_data = {};
		for room in default_dungeon_enemy_map[dungeon]:
			var enemies = [];
			for enemy in default_dungeon_enemy_map[dungeon][room]:
				enemies.push_back(dungeon_enemy_pool[random.randi_range(0, len(dungeon_enemy_pool)-1)]);
			dungeon_data[room] = enemies;
		dungeon_enemy_map[dungeon] = dungeon_data;

func randomize_shops():
	var spot_list = default_shop_map.keys();
	var item_list = default_shop_map.values();

	for spot in spot_list:
		shop_map[spot] = item_list.pop_at(random.randi_range(0, len(item_list)-1));

func randomize_items():
	var location_list: Array = default_item_map.keys();
	var item_list: Array = default_item_map.values();
	
	if item_randomization == ITEM_RANDOMIZATIONS.ITEMS_ONLY:
		location_list = [];
		item_list = [];
		for location in default_item_map:
			var item = default_item_map[location];
			if not "item" in item and not "sword_scroll" in item and not "heart_container" in item:
				item_map[location] = item;
			else:
				location_list.push_back(location);
				item_list.push_back(item);

	var sword = item_list.pop_at(item_list.find("item/sword/1"));
	if not randomize_wood_sword:
		var wsci1 = location_list.pop_at(location_list.find("cave/wooden_sword_cave/item_1"));
		item_map[wsci1] = sword;
	else:
		var available_locations = get_locations_accesible_with_keys([], location_list);
		var chosen_location = available_locations[random.randi_range(0, len(available_locations)-1)];
		location_list.erase(chosen_location);
		item_map[chosen_location] = sword;

	var all_placed = false;
	var location_list_backup = location_list.duplicate();
	var item_list_backup = item_list.duplicate();
	while not all_placed:
		var keys = ["sword", "bombs", "hearts_3"];
		while len(item_list) > 0:
			var available_locations = get_locations_accesible_with_keys(keys, location_list);
			if len(available_locations) == 0:
				item_list = item_list_backup.duplicate();
				location_list = location_list_backup.duplicate();
				break;
			var location = available_locations[random.randi_range(0, len(available_locations)-1)];
			location_list.erase(location);
			
			var item;
			if len(available_locations) < 5:
				var prog_index = get_progression_item_index(item_list, keys, location_list);
				item = item_list.pop_at(prog_index);
			else:
				item = item_list.pop_at(random.randi_range(0, len(item_list)-1));
			
			var new_keys = get_item_keys(item);
			keys = append_keys(keys, new_keys);
			item_map[location] = item;
		if len(item_list) == 0:
			all_placed = true;
		else:
			print("Route is unbeatable running place items again");
		

func append_keys(keys, new_keys) -> Array:
	for new_key in new_keys:
		if not new_key in keys:
			if new_key == "hearts":
				var i = 0;
				for key in keys:
					if "hearts" in key:
						if keys[i] in ["hearts_4", "hearts_5", "hearts_10", "hearts_12", "hearts_16"]:
							keys.push_back(keys[i]);
						keys[i] = "hearts_"+ str(int(key.split("_")[1])+1);
						break;
					i+=1;
			else:
				keys.push_back(new_key);
	# Check if should add triforce
	var failed = "triforce" in keys;
	if not failed:
		for key in TRIFORCE_KEYS:
			if not key in keys:
				failed = true;
		if not failed:
			keys.push_back("triforce");
	
	# Check if should add food
	if not "food" in keys:
		for shop_item in shop_map:
			if "food" in keys: break;
			if shop_map[shop_item] == "counter/food/10":
				var food_keys = get_gates_for_location(shop_item);
				var shop = shop_item.split("/")[0];
				var cave_name = shop+"_cave";
				if shop == "potion_shop":
					cave_name = "potion_cave";
				for cave in caves_map:
					if "food" in keys: break;
					if caves_map[cave] == cave_name:
						var cave_keys = get_gates_for_location(cave);
						cave_keys.append_array(food_keys);
						
						var hasnt_failed = true;
						for key in cave_keys:
							if not key in keys:
								hasnt_failed = false;
								break;
						if hasnt_failed:
							keys.push_back("food");
	
	return keys;

func get_progression_item_index(item_list: Array, current_keys, location_list):
	var progression_item_indexes = [];
	var i = 0;
	for item in item_list:
		var before_locations = get_locations_accesible_with_keys(current_keys, location_list);
		var keys = append_keys(current_keys.duplicate(), get_item_keys(item));
		var after_locations = get_locations_accesible_with_keys(keys, location_list);
		if len(before_locations) < len(after_locations):
			progression_item_indexes.push_back(i);
		
		i+=1;
	
	if len(progression_item_indexes) > 0:
		return progression_item_indexes[random.randi_range(0, len(progression_item_indexes)-1)];
	
	return random.randi_range(0, len(item_list)-1);

func get_item_keys(item_string) -> Array:
	if "item/power_bracelet" in item_string:
		return ["power_bracelet"];
	elif "item/sword" in item_string:
		return ["sword", "bombs"];
	elif "counter/heart_container" in item_string:
		return ["hearts"];
	elif "item/candle" in item_string:
		return ["candle"];
	elif "item/arrow" in item_string:
		return ["arrow"];
	elif "item/bow" in item_string:
		return ["bow"];
	elif "counter/key" in item_string:
		return ["key_"+item_string.split("/")[3]];
	elif "item/raft" in item_string:
		return ["raft"];
	elif "item/step_ladder" in item_string:
		return ["step_ladder"];
	elif "item/recorder" in item_string:
		return ["flute"];
	elif "item/magic_key" in item_string:
		var rv = [];
		for i in range(TOTAL_KEYS):
			rv.push_back("key_"+str(i+1));
		return rv;
	elif "item/letter" in item_string:
		return ["letter"];
	
	return [];

# Keys are in reference to gates not actual keys
func get_locations_accesible_with_keys(keys: Array, locations: Array) -> Array:
	var rv = [];
	for location in locations:
		var gates = get_gates_for_location(location);
		var failed = false;
		for gate in gates:
			if not gate in keys:
				failed = true;
		if not failed:
			rv.push_back(location);
	
	return rv;

func get_gates_for_location(location: String) -> Array:
	var gates: Array = location_gates[location].split("/");
	var location_data = location.split("/");
	
	match location_data[0]:
		"cave":
			for cave in caves_map:
				if caves_map[cave] in location:
					gates.append_array(location_gates[cave].split("/"));
		"dungeon":
			for entrance in dungeons_map:
				if dungeons_map[entrance] == "level_"+str(location_data[1]):
					gates.append_array(location_gates[entrance].split("/"));
		"shop_1":
			for cave in caves_map:
				if "shop_1" in caves_map[cave]:
					gates.append_array(location_gates[cave].split("/"));
		"shop_2":
			for cave in caves_map:
				if "shop_2" in caves_map[cave]:
					gates.append_array(location_gates[cave].split("/"));
		"shop_3":
			for cave in caves_map:
				if "shop_3" in caves_map[cave]:
					gates.append_array(location_gates[cave].split("/"));
		"shop_4":
			for cave in caves_map:
				if "shop_4" in caves_map[cave]:
					gates.append_array(location_gates[cave].split("/"));
		_:
			pass;
	
	# remove all occurance of empty string
	while gates.has(""):
		gates.erase("");

	return gates;

func get_dungeon_entrance_of(level: Inventory.LEVELS) -> Inventory.LEVELS:
	var level_name;
	match level:
		Inventory.LEVELS.ONE:
			level_name = "level_1";
		Inventory.LEVELS.TWO:
			level_name = "level_2";
		Inventory.LEVELS.THREE:
			level_name = "level_3";
		Inventory.LEVELS.FOUR:
			level_name = "level_4";
		Inventory.LEVELS.FIVE:
			level_name = "level_5";
		Inventory.LEVELS.SIX:
			level_name = "level_6";
		Inventory.LEVELS.SEVEN:
			level_name = "level_7";
		Inventory.LEVELS.EIGHT:
			level_name = "level_8";
		Inventory.LEVELS.NINE:
			level_name = "level_9";
	
	var entrance;
	for ent in dungeons_map:
		if dungeons_map[ent] == level_name:
			entrance = ent;
			break;
	
	match entrance:
		"entrance_1":
			return Inventory.LEVELS.ONE;
		"entrance_2":
			return Inventory.LEVELS.TWO;
		"entrance_3":
			return Inventory.LEVELS.THREE;
		"entrance_4":
			return Inventory.LEVELS.FOUR;
		"entrance_5":
			return Inventory.LEVELS.FIVE;
		"entrance_6":
			return Inventory.LEVELS.SIX;
		"entrance_7":
			return Inventory.LEVELS.SEVEN;
		"entrance_8":
			return Inventory.LEVELS.EIGHT;
		"entrance_9":
			return Inventory.LEVELS.NINE;
	
	# This should never be reached
	return Inventory.LEVELS.OVERWORLD;
