extends Node2D

func _ready():
	for node in get_children():
		if node is Control:
			node.focus_entered.connect(_play_sound);

func _play_sound():
	SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
