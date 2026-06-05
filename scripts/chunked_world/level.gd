extends Node3D

@export var level: Inventory.LEVELS = Inventory.LEVELS.ONE;

func _ready():
	Inventory.current_level = level;
	EnemyTracker.reset_dungeon_data_on_enter(level);
	SoundSystem.play_dungeon_music();
