extends Node3D

@onready var link = $Link;

func _ready():
	var level = Randomizer.get_dungeon_entrance_of(Inventory.current_level)
	link.global_position = Inventory.LEVEL_END_TELEPORT_POSITIONS[level];
	Inventory.current_level = Inventory.LEVELS.OVERWORLD;
	SoundSystem.play_overworld_music();
