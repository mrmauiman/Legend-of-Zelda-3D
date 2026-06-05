extends CharacterBody3D

const SMASH_PARTICLES: PackedScene = preload("res://scenes/enemies/overworld/rock_smash_particles.tscn");

@export var max_bounces: int = 4;

var bounces: int = 0;

func explode():
	var particles = SMASH_PARTICLES.instantiate();
	particles.position = global_position;
	get_tree().root.add_child(particles);
	queue_free();
	SoundSystem.play("res://audio/sfx/BombExplosion.wav", global_position);

func _physics_process(delta):
	velocity.y -= 12.8 * delta;
	move_and_slide();
	
	var collision = get_last_slide_collision();
	if collision:
		var normal = collision.get_normal();
		if normal.angle_to(Vector3.UP) < deg_to_rad(5) or bounces >= max_bounces:
			explode()
		else:
			velocity = Vector3((normal.x * 9.6 * randf_range(0.6, 1)) + (velocity.x/2.0), normal.y * 6.4, (normal.z * 9.6) * randf_range(0.6, 1) + (velocity.z/2.0));
			bounces += 1;
			SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);


func _on_hit_box_hit(_body):
	explode()
