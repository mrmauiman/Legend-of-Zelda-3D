class_name Bomb extends CharacterBody3D

@export var fuse_time: float = 3;
@export var gravity: float = -32;
const TERMINAL_VELOCITY: float = -120;

const SMOKE_SCENE: PackedScene = preload("res://scenes/link/bomb_explosion.tscn");

var timer: float = 0;

func show_frame(frame: int):
	for texture in %Texture.get_children():
		if texture.name == "Bomb" + str(frame):
			texture.visible = true;
		else:
			texture.visible = false;

func _process(delta):
	timer += delta;
	var frame = ceili((timer/fuse_time) * %Texture.get_child_count());
	show_frame(frame);
	if timer >= fuse_time:
		var smoke = SMOKE_SCENE.instantiate();
		smoke.position = global_position;
		get_tree().root.add_child(smoke);
		queue_free();
		SoundSystem.play("res://audio/sfx/BombExplosion.wav", global_position);

func _physics_process(delta):
	velocity.y += gravity * delta;
	velocity.y = max(velocity.y, TERMINAL_VELOCITY);
	
	if is_on_floor():
		velocity = Vector3(0, velocity.y, 0);
	
	move_and_slide();
