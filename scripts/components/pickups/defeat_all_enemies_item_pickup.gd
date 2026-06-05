class_name DefeatAllEnemiesItemPickup extends ItemPickup

@export var enemies: Node3D;

func all_enemies_defeated() -> bool:
	return enemies.get_child_count() == 0;

func _process(_delta):
	var enemies_defeated = all_enemies_defeated();
	if not visible and enemies_defeated:
		SoundSystem.play("res://audio/sfx/item_appeared.wav", global_position);
	visible = enemies_defeated;

func can_pickup(_link):
	return all_enemies_defeated();
