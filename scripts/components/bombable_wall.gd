class_name BombableWall extends StaticBody3D


func _on_area_3d_area_entered(area):
	if area is HitBox and area.is_bomb:
		SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
		queue_free();
