class_name Gleeok extends Node3D

@export_range(2, 4, 1) var head_count: int = 2;

func _ready():
	var count = 0;
	for node in get_children():
		if node is GleeokHead:
			count += 1;
			if count > head_count:
				node.queue_free();

var roar_timer: float = 2.5;
func _process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = 2.5;

func remove_head():
	head_count -= 1;
	if head_count <= 0:
		die();

func die():
	var drop = EnemyDrops.get_drop(EnemyDrops.ENEMY_GROUPS.D);
	EnemyDrops.spawn_drop(drop, global_position);
	
	queue_free();
