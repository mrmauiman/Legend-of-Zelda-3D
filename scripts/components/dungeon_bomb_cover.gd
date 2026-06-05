class_name DungeonBombCover extends Node3D

func destroy():
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
	queue_free();

func _on_area_3d_area_entered(area: Area3D):
	if area is HitBox and area.is_bomb:
		destroy();
