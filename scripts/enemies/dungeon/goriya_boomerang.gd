extends CharacterBody3D

@export var direction: Vector3;
@export var goriya: CharacterBody3D;

@export var blue: bool = false;
@export var speed: float = 9.6;
@export var spin_speed: float = 360*4;

var returning = false;

var timer: float = 0;
var boomerang_model;
var sfx: AudioStreamPlayer3D;

func start_returning():
	returning = true;
	%CollisionShape3D.disabled = true;

func _ready():
	if not direction or not goriya:
		print("Either Target or Link were not set.  Destroying self");
		queue_free();
	
	sfx = SoundSystem.play("res://audio/sfx/Boomerang.wav", global_position);

	boomerang_model = %BoomerangModel;
	if blue:
		boomerang_model.texture = load("res://sprites/link/magic_boomerang.png");
	goriya.boomerang_thrown = true;
	
		

func _physics_process(delta):
	if  not goriya:
		queue_free();
		return;
	if sfx: sfx.global_position = global_position;
	boomerang_model.rotation.x += deg_to_rad(spin_speed * delta);
	if returning:
		var goriya_pos = goriya.global_position + (Vector3.UP * 0.8)
		look_at(goriya_pos);
		velocity = global_position.direction_to(goriya_pos) * speed;
		move_and_slide();
		if global_position.distance_to(goriya_pos) < 0.8: 
			goriya.boomerang_thrown = false;
			if sfx: sfx.stop();
			queue_free();
	else:
		timer += delta;
		if timer >= 1:
			start_returning();
		
		if %RayCast3D.is_colliding():
			var collision_point = %RayCast3D.get_collision_point();
			position = collision_point + (Vector3.UP * 0.8);
		
		look_at(global_position + direction);
		
		velocity = direction.normalized() * speed;
		var collision: KinematicCollision3D = move_and_collide(velocity * delta);
		if collision:
			start_returning();


func _on_hit_box_hit(_body: Variant):
	start_returning();

func _exit_tree():
	if sfx: sfx.stop();
