extends Node3D

const GEL_TEXTURE_PATHS = {
	Inventory.LEVELS.ONE: ["res://sprites/enemies/dungeon/gel_1.png", "res://sprites/enemies/dungeon/gel_2.png"],
	Inventory.LEVELS.TWO: ["res://sprites/enemies/dungeon/lvl2_gel_1.png", "res://sprites/enemies/dungeon/lvl2_gel_2.png"],
	Inventory.LEVELS.THREE: ["res://sprites/enemies/dungeon/lvl3_gel_1.png", "res://sprites/enemies/dungeon/lvl3_gel_2.png"],
	Inventory.LEVELS.FOUR: ["res://sprites/enemies/dungeon/lvl4_gel_1.png", "res://sprites/enemies/dungeon/lvl4_gel_2.png"],
	Inventory.LEVELS.FIVE: ["res://sprites/enemies/dungeon/lvl5_gel_1.png", "res://sprites/enemies/dungeon/lvl5_gel_2.png"],
	Inventory.LEVELS.SIX: ["res://sprites/enemies/dungeon/lvl6_gel_1.png", "res://sprites/enemies/dungeon/lvl6_gel_2.png"],
	Inventory.LEVELS.SEVEN: ["res://sprites/enemies/dungeon/lvl7_gel_1.png", "res://sprites/enemies/dungeon/lvl7_gel_2.png"],
	Inventory.LEVELS.EIGHT: ["res://sprites/enemies/dungeon/lvl8_gel_1.png", "res://sprites/enemies/dungeon/lvl8_gel_2.png"],
	Inventory.LEVELS.NINE: ["res://sprites/enemies/dungeon/lvl9_gel_1.png", "res://sprites/enemies/dungeon/lvl9_gel_2.png"]
};

@onready var frame_1: Sprite3D = $Frame1;
@onready var frame_2: Sprite3D = $Frame2;

func _ready():
	if GEL_TEXTURE_PATHS.has(Inventory.current_level):
		var textures = GEL_TEXTURE_PATHS[Inventory.current_level];
		frame_1.texture = load(textures[0]);
		frame_2.texture = load(textures[1]);
