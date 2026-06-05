extends CharacterBody3D

@export var speed: float = 4.8;
@export var direction: Vector3;
@export var travel_time: float = 0.5;
@export var life_time: float = 1;

var timer: float = 0;
var stationary: bool = false;

func _ready():
	if not direction: 
		queue_free();

func _physics_process(delta):
	timer += delta;
	if timer < travel_time and not stationary:
		velocity = speed * direction;
	elif timer < life_time:
		velocity = Vector3.ZERO;
		%LinkHitBox.get_node("CollisionShape3D").disabled = false;
	else:
		queue_free();
	
	if %RayCast3D.is_colliding():
		position = %RayCast3D.get_collision_point() + (Vector3.UP * 0.8);
	
	move_and_collide(velocity * delta);
