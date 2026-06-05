class_name Manhandla extends Enemy

var heads = [true, true, true, true];

# Components
@onready var state_machine: StateMachine = %StateMachine;
@onready var model: Node3D = %Model;

const GRAVITY = 64;

@export var min_move_speed: float = 3.2;
@export var max_move_speed: float = 12.8;
@export var min_spin_speed: float = 180;
@export var max_spin_speed: float = 720;

var move_speed: float = 0;
var spin_speed: float = 0;

var dir = get_starting_dir();

func update_held_item():
	pass;

func get_starting_dir() -> Vector3:
	var x = ((randi_range(0, 1) * 2)-1);
	var z = ((randi_range(0, 1) * 2)-1);
	return Vector3(x, 0, z).normalized();

func _process(_delta):
	var head_count: float = 0;
	for head in heads:
		if head: head_count+= 1;
	var head_ratio = head_count/len(heads);
	move_speed = lerpf(max_move_speed, min_move_speed, head_ratio);
	spin_speed = lerpf(max_spin_speed, min_spin_speed, head_ratio);

var roar_timer: float = 2.5;

func _physics_process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = 2.5;
	rotation.y += deg_to_rad(spin_speed) * delta;
	
	var temp_vel = dir * move_speed;
	velocity.x = temp_vel.x;
	velocity.z = temp_vel.z;
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();
	
	if is_on_wall():
		var x_comp = -Vector3(dir.x, 0, 0).normalized();
		var z_comp = -Vector3(0, 0, dir.z).normalized();
		var wall_norm = get_wall_normal();
		if wall_norm.is_equal_approx(x_comp) or wall_norm.is_equal_approx(z_comp):
			dir = dir.bounce(wall_norm);

func check_dead():
	for head in heads:
		if head:
			return;
	die();
