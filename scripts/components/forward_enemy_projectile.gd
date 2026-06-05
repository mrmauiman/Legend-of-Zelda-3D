extends CharacterBody3D

@export var speed: float = 12.8;
@export var max_life: float = 30;
@export var snap_to_ground: bool = true;

var timer: float = 0;
var direction: Vector3;

var objects_to_ignore = [];

func _ready():
	if not direction: 
		push_warning("Direction not set on enemy projectile: ", self);
		queue_free();
	timer = 0;

func _physics_process(delta):
	timer += delta;
	if timer >= max_life:
		queue_free();
		return;
	if snap_to_ground and %RayCast3D.is_colliding():
		var offset = (Vector3.UP * 0.4);
		if len(%WaterChecker.get_overlapping_bodies()) > 0:
			offset = (Vector3.UP * 0.7)
		position = %RayCast3D.get_collision_point() + offset;
	
	look_at(global_position + direction);
	
	velocity = direction * speed;
	
	var collision = move_and_collide(velocity * delta);
	if collision:
		if not collision.get_collider() in objects_to_ignore:
			queue_free();

func blocked(_by):
	destroy();

func parried(_by):
	direction *= -1;
	%HitBox.damage *= 2;
	%HitBox.set_collision_layer_value(3, false);
	%HitBox.set_collision_layer_value(2, true);
	%HitBox.set_collision_mask_value(3, true);
	%HitBox.set_collision_mask_value(2, false);

func hit(_by):
	destroy();

func destroy():
	queue_free();
