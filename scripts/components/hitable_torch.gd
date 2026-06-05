extends Node3D

func _on_hurt_box_area_entered(area):
	if area is HitBox:
		if area.is_sword:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
			queue_free();
