extends CharacterBody3D

@export var speed: float = 6.4;
var direction: Vector3 = Vector3.BACK;
var spawn_timer = 0.5;

signal dismount;

func _ready():
	look_at(global_position + direction);
	if $RayCast3D.is_colliding():
		global_position.y = $RayCast3D.get_collision_point().y;

func _physics_process(delta):
	velocity = direction * speed;
	var collision = move_and_collide(velocity * delta);
	spawn_timer -= delta;
	if collision and spawn_timer <= 0:
		dismount.emit();
	
