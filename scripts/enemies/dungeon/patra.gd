class_name Patra extends Enemy

@onready var drones: Node3D = get_node("%Drones");
@onready var health: Health = get_node("%Health");
@onready var model: Node3D = get_node("PatraModel");
@onready var color_animation_player: AnimationPlayer = model.get_node("%ColorAnimationPlayer");

@export var inner_radius: float = 1.6;
@export var outer_radius: float = 8;
@export var spin_speed: float = 180;
@export var inner_radius_time: float = 1.5;
@export var outer_radius_time: float = 1;
@export var radius_transition_time: float = 0.5;
@export var turn_chance: float = 32;
@export var turn_time: float = 0.3;
@export var move_speed: float = 3.2;

var current_angle: float = 0;
var current_radius: float = inner_radius;
var radius_timer: float = 0;
var dir: Vector3 = Vector3.UP;
var turn_timer: float = turn_time;

const GRAVITY: float = 64;

func update_held_item():
	pass;

func _change_dir():
	dir = Vector3.RIGHT.rotated(Vector3.UP, randf_range(0, 360));

func _should_turn():
	return randf_range(0, 100) < turn_chance;

func _handle_movement(delta):
	turn_timer -= delta;
	if turn_timer <= 0:
		turn_timer += turn_time;
		if _should_turn(): _change_dir();
	var vel_y = velocity.y;
	velocity = dir * move_speed;
	var next_pos = position + (velocity * delta);
	if abs(next_pos.x) > 3.2:
		dir.x *= -1;
		velocity.x *= -1;
	if abs(next_pos.z) > 4.8:
		dir.z *= -1;
		velocity.z *= -1;
	velocity.y = vel_y;

func _position_drones(radius, angle):
	var offset = Vector3(radius, 0, 0).rotated(Vector3.UP, angle);
	for drone: PatraDrone in drones.get_children():
		var index = int(str(drone.name)[-1]);
		drone.global_position = global_position + offset.rotated(Vector3.UP, deg_to_rad(45) * (index-1));

func _set_current_radius(delta):
	radius_timer += delta;
	if radius_timer < inner_radius_time:
		current_radius = inner_radius;
	elif radius_timer < inner_radius_time + radius_transition_time:
		current_radius = lerpf(inner_radius, outer_radius, (radius_timer-inner_radius_time)/radius_transition_time);
	elif radius_timer < inner_radius_time + radius_transition_time + outer_radius_time:
		current_radius = outer_radius;
	else:
		current_radius = lerpf(inner_radius, outer_radius, 1-((radius_timer-(inner_radius_time + radius_transition_time + outer_radius_time))/radius_transition_time));
		if radius_timer >= inner_radius_time + radius_transition_time + outer_radius_time + radius_transition_time:
			radius_timer = 0;

func _ready():
	_position_drones(inner_radius, current_angle);

func _physics_process(delta):
	_set_current_radius(delta);
	current_angle += delta * spin_speed;
	if current_angle >= 360:
		current_angle -= 360;
	_position_drones(current_radius, deg_to_rad(current_angle))
	_handle_movement(delta);
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();


func _on_hurt_box_area_entered(area):
	if area is HitBox and drones.get_child_count() == 0 and area.is_sword:
		var hitbox: HitBox = area;
		color_animation_player.play("hurt");
		health.take_damage(hitbox.get_damage(false));
		hitbox.hit.emit(self);
		if health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
