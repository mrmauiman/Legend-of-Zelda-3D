class_name Whirlwind extends CharacterBody3D

@export var life_time: float = 4;
@export var move_speed: float = 6.4

var timer: float = life_time;
var link;

func teleport():
	var temp_link = link;
	link = null;
	temp_link.teleport_to(Inventory.LEVEL_END_TELEPORT_POSITIONS[Inventory.recorder_current_teleport]);
	queue_free();

func _physics_process(delta):
	timer -= delta;
	if timer <= 0:
		queue_free();
	
	if link:
		link.global_position = global_position;
	
	velocity = Vector3.RIGHT * move_speed;
	move_and_slide();


func _on_grabber_body_entered(body):
	if body.is_in_group("Link"):
		link = body;
		link.get_grabbed();
		DoorAnimation.enter();
		get_tree().create_timer(1.2, true).timeout.connect(teleport);
