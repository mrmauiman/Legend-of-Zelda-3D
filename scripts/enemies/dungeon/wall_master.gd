extends Enemy

@onready var room_center: Vector3 = get_parent().global_position;
@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("ColorAnimationPlayer");
@onready var grab_shape: Area3D = model.get_node("GrabShape");
@onready var health: Health = %Health;

@export var move_speed: float = 4.8;

# Room Size: 12 x 7

const ROOM_WIDTH: float = 11 * 1.6;
const ROOM_HEIGHT: float = 6 * 1.6;

var dir: Vector3 = Vector3.ZERO;

var holding = null;
var animation_played = false;
var stun_timer: float = 0;

func update_held_item():
	pass;

func about_to_leave_room():
	match dir:
		Vector3(0, 0, 1):
			return global_position.z > (room_center.z + (ROOM_HEIGHT/2.0) - 3.2);
		Vector3(0, 0, -1):
			return global_position.z < (room_center.z - (ROOM_HEIGHT/2.0) + 3.2);
		Vector3(1, 0, 0):
			return global_position.x > (room_center.x + (ROOM_WIDTH/2.0) - 3.2);
		Vector3(-1, 0, 0):
			return global_position.x < (room_center.x - (ROOM_WIDTH/2.0) + 3.2);

func left_room():
	match dir:
		Vector3(0, 0, 1):
			return global_position.z > (room_center.z + (ROOM_HEIGHT/2.0) + 0.8);
		Vector3(0, 0, -1):
			return global_position.z < (room_center.z - (ROOM_HEIGHT/2.0) - 0.8);
		Vector3(1, 0, 0):
			return global_position.x > (room_center.x + (ROOM_WIDTH/2.0) + 0.8);
		Vector3(-1, 0, 0):
			return global_position.x < (room_center.x - (ROOM_WIDTH/2.0) - 0.8);

func get_spawn_position():
	var choice = randi_range(1, 4);
	match(choice):
		1:
			dir = Vector3(0, 0, 1);
			return Vector3(randf_range(room_center.x - (ROOM_WIDTH/2.0), room_center.x + (ROOM_WIDTH/2.0)), room_center.y, room_center.z - (ROOM_HEIGHT/2) - 3.2);
		2: 
			dir = Vector3(0, 0, -1);
			return Vector3(randf_range(room_center.x - (ROOM_WIDTH/2.0), room_center.x + (ROOM_WIDTH/2.0)), room_center.y, room_center.z + (ROOM_HEIGHT/2) + 3.2);
		3: 
			dir = Vector3(1, 0, 0);
			return Vector3(room_center.x - (ROOM_WIDTH/2) - 3.2, room_center.y, randf_range(room_center.z - (ROOM_HEIGHT/2.0), room_center.z + (ROOM_HEIGHT/2.0)));
		4: 
			dir = Vector3(-1, 0, 0);
			return Vector3(room_center.x + (ROOM_WIDTH/2) + 3.2, room_center.y, randf_range(room_center.z - (ROOM_HEIGHT/2.0), room_center.z + (ROOM_HEIGHT/2.0)));
	print("Something went wrong and choice was not a valid value!");
	return null;

func _animation_finished(anim):
	if anim == "grab":
		if holding:
			animation_player.play("hold");
		else:
			animation_player.play("idle");

func _ready():
	global_position = get_spawn_position();
	animation_player.animation_finished.connect(_animation_finished);
	animation_player.play("idle");
	grab_shape.body_entered.connect(_on_grab_shape_body_entered);

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		stun_timer = Inventory.clock_timer;
	
	if stun_timer > 0:
		stun_timer -= delta;
		return;

	if left_room():
		animation_player.play("idle");
		global_position = get_spawn_position();
		animation_played = false;
		if holding:
			holding.teleport_to_dungeon_beginning();
			holding = null;

	if holding and not animation_played and about_to_leave_room():
		animation_played = true;
		DoorAnimation.enter();

	look_at(global_position - dir);

	if holding:
		holding.global_position = global_position;

	velocity = dir * move_speed;
	move_and_slide();

func _on_grab_shape_body_entered(body):
	if body.is_in_group("Link") and not health.is_dead():
		holding = body;
		body.get_grabbed();

func _on_sight_body_entered(body):
	if animation_player.current_animation == "idle" and body.is_in_group("Link"):
		animation_player.play("grab");


func _on_hurt_box_area_entered(area):
	if area is HitBox and not holding:
		color_animation_player.play("hurt");
		if area.stun_time > 0:
			stun_timer = area.stun_time;
		health.take_damage(area.get_damage());
		if health.is_dead():
			die();
