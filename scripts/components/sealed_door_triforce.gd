extends StaticBody3D

func destroy():
	queue_free();

func unlock():
	SoundSystem.play_global("res://audio/sfx/door_opened.wav");
	destroy();

func lock():
	SoundSystem.play_global("res://audio/sfx/door_opened.wav");

func _has_triforce() -> bool:
	for level in Inventory.levels:
		if level == Inventory.LEVELS.OVERWORLD: continue;
		if level == Inventory.LEVELS.NINE: continue;
		if not Inventory.levels[level].triforce_piece: return false;
	return true;

func _ready():
	lock();

func _process(_delta):
	if _has_triforce():
		destroy();
