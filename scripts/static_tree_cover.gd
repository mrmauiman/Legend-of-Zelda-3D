extends StaticBody3D


var min_leaves_height: float = 0;
var max_front_leaves_height: float = 1.1;
var max_surrounded_leaves_height: float = 1.6;

func _ready():
	get_tree().create_timer(0.25).timeout.connect(set_tree_height);

func set_tree_height():
	var open = false;
	for raycast: RayCast3D in %RayCasts.get_children():
		if not raycast.is_colliding():
			open = true;
	if open:
		%Sprite.position.y = randf_range(min_leaves_height, max_front_leaves_height);
	else:
		%Sprite.position.y = randf_range(min_leaves_height, max_surrounded_leaves_height);
	%RayCasts.queue_free();

func destroy():
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
	queue_free();
