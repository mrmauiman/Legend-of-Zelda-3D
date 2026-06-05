extends CharacterBody3D

@export var gravity: float = -10;
const TERMINAL_VELOCITY: float = -120;
var dir: Vector3
var bites: float = 32;

func attract_monsters():
	for monster in %AttractionArea.get_overlapping_bodies():
		if monster is Enemy and monster.attracted_to_food:
			monster.set_food(self);

func take_bite(amount):
	bites -= amount;
	if bites <= 0:
		queue_free();

func _ready():
	look_at(global_position + dir);

func _physics_process(delta):
	velocity.y += gravity * delta;
	velocity.y = max(velocity.y, TERMINAL_VELOCITY);
	
	attract_monsters();
	
	if is_on_floor():
		velocity = Vector3(0, velocity.y, 0);
	
	move_and_slide();
