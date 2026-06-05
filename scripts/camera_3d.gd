extends Node3D

@export_range(0, 1, 0.01) var mouse_sensitivity: float = 0.05;
@export var input_sensitivity: float = 200;
@export var camera_speed: float = 720;
@export var top_tilt_limit: float = 25;
@export var bottom_tilt_limit: float = -15;
@export var camera_offset: Vector3 = Vector3(0, 1.6, 0);


@onready var link: CharacterBody3D = get_parent();
@onready var link_model: Node3D = link.get_node("LinkModel");
@onready var camera: Camera3D = %Camera3D;
@onready var target_arrow: Sprite3D = get_node("TargetArrow");
@onready var target_area: Area3D = link.get_node("%TargetArea");

var h_input: float = 0;
var v_input: float = 0;
var goal_y_rot: float = 0;

var offset: Vector3;

enum STATES {FREE, LOCKED, TARGET, CUTSCENE};
var state: STATES = STATES.FREE;

var target: Enemy;
var target_list: Array[Enemy] = [];
var world_camera: Camera3D;

var cycle_left: bool = false;
var cycle_right: bool = false;

func has_target() -> bool:
	return !!target;

func get_target_tangent(velocity, current_animation):
	var dir_to_target = (target.global_position - link.global_position);
	dir_to_target.y = 0;
	var tangent = dir_to_target.rotated(Vector3.UP, deg_to_rad(90)).normalized();
	
	if current_animation in ["roll_right", "r_side_hop"]:
		tangent *= -1;
	
	return tangent * velocity.length();
	

func orient_behind_link():
	var spring_forward = camera.global_transform.basis.z;
	spring_forward = Vector2(-spring_forward.x, spring_forward.z);
	spring_forward = spring_forward.normalized();
	var link_forward = link.get_node("%LinkModel").global_transform.basis.z;
	link_forward = Vector2(link_forward.x, -link_forward.z);
	link_forward = link_forward.normalized();
	goal_y_rot = rotation.y + spring_forward.angle_to(link_forward);

func lock_camera():
	orient_behind_link();
	state = STATES.LOCKED;

func check_targets(set_target=true):
	const TARGET_STEPS = 5;
	const TARGET_STEP_SIZE = 3.2;
	var closest_angle = 90;
	var bodies = target_area.get_overlapping_bodies();
	if set_target:
		target = null;
	target_list = [];
	var dist_sorted_bodies = [];
	for body in bodies:
		if body is Enemy:
			var vec_to_enemy: Vector3 = body.global_position - link.global_position;
			for i in range(1, TARGET_STEPS+1, 1):
				if len(dist_sorted_bodies) < i:
					dist_sorted_bodies.push_back([]);
				if vec_to_enemy.length() >= (i-1) * TARGET_STEP_SIZE and vec_to_enemy.length() < i * TARGET_STEP_SIZE:
					dist_sorted_bodies[i-1].push_back(body);
					break;

	for step in dist_sorted_bodies:
		for body in step:
			var vec_to_enemy: Vector3 = body.global_position - link.global_position;
			var forward = target_area.transform.basis.z;
			var vec_to_enemy_2D = Vector2(vec_to_enemy.x, vec_to_enemy.z);
			var forward_2D = Vector2(forward.x, forward.z);
			var angle = rad_to_deg(forward_2D.angle_to(vec_to_enemy_2D.normalized()));
			var placed = false;
			var i = 0;
			for enemy in target_list:
				var other_vec = enemy.global_position - link.global_position;
				var other_vec_2D = Vector2(other_vec.x, other_vec.z);
				var other_angle = rad_to_deg(forward_2D.angle_to(other_vec_2D.normalized()));
				if other_angle > angle:
					target_list.insert(i, body);
					placed = true;
					break;
				i+=1;
			if not placed:
				target_list.push_back(body);
			if set_target and abs(angle) < abs(closest_angle):
				closest_angle = angle;
				target = body;


func _ready():
	goal_y_rot = rotation.y;
	offset = position;
	world_camera = camera.duplicate();
	get_tree().root.add_child.call_deferred(world_camera);


var mouse_motion = false;
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_motion = true;
		h_input = event.screen_relative.x * mouse_sensitivity;
		v_input = -event.screen_relative.y * mouse_sensitivity;

func _process(_delta):
	if not mouse_motion:
		h_input = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left");
		v_input = Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down");
	mouse_motion = false;
	
	if Input.is_action_just_pressed("target"):
		if not target:
			lock_camera();
		elif state != STATES.TARGET:
			orient_behind_link();
			state = STATES.TARGET;
			target_arrow.frame = 1;
		elif Settings.target_mode == Settings.TARGET_MODES.TOGGLE:
			state = STATES.FREE;
			target_arrow.frame = 0;
			position = offset;
	
	if Input.is_action_just_released("target"):
		if state == STATES.LOCKED:
			state = STATES.FREE;
		elif state == STATES.TARGET and Settings.target_mode == Settings.TARGET_MODES.HOLD:
			state = STATES.FREE;
			target_arrow.frame = 0;
			position = offset;
	
	cycle_right = Input.is_action_just_pressed("cycle_target_right");
	cycle_left = Input.is_action_just_pressed("cycle_target_left");

func up_down_tilt(delta):
	var inversion = -1 if Settings.camera_y_inverted else 1;
	rotation.x += inversion * v_input * deg_to_rad(input_sensitivity * Settings.camera_sensitivity) * delta;
	rotation.x = clampf(rotation.x, deg_to_rad(bottom_tilt_limit), deg_to_rad(top_tilt_limit));

func play_ending_cutscene():
	state = STATES.CUTSCENE;
	position.z -= 0.8;
	rotation.x = deg_to_rad(top_tilt_limit);
	goal_y_rot = deg_to_rad(-90);

func _physics_process(delta):
	$SpringArm3D.spring_length = Settings.camera_zoom;
	target_area.rotation.y = rotation.y + deg_to_rad(180);
	world_camera.global_transform = camera.global_transform;
	if target:
		target_arrow.visible = true;
		target_arrow.global_position = target.global_position + target.target_arrow_offset;
	else:
		target_arrow.visible = false;
	up_down_tilt(delta);
	match state:
		STATES.FREE:
			var inversion = -1 if Settings.camera_x_inverted else 1;
			goal_y_rot -= inversion * h_input * deg_to_rad(input_sensitivity * Settings.camera_sensitivity) * delta;
			check_targets();
			var pos = link.global_position + camera_offset;
			if pos.x == camera.global_position.x and pos.z == camera.global_position.z:
				pos.z += 1;
			camera.look_at(pos);
		STATES.LOCKED:
			camera.look_at(link.global_position + camera_offset);
		STATES.TARGET:
			if not target:
				state = STATES.FREE;
				target_arrow.frame = 0;
			else:
				check_targets(false);
				if cycle_left:
					for i in range(len(target_list)):
						if target_list[i] == target:
							target = target_list[clamp(i-1, 0, len(target_list)-1)];
							break;
				if cycle_right:
					for i in range(len(target_list)):
						if target_list[i] == target:
							target = target_list[clamp(i+1, 0, len(target_list)-1)];
							break;
				#goal_y_rot -= h_input * deg_to_rad(input_sensitivity) * delta;
				var link_look_at = target_arrow.global_position;
				link_look_at.y = link_model.global_position.y;
				if link.state != link.STATES.ATTACK or link.animation_player.current_animation != "jump_over_attack":
					link_model.look_at(link_look_at);
					link_model.rotate_y(deg_to_rad(180));
				orient_behind_link();
				#camera.look_at(target.global_position.lerp(link.global_position, 0.5) + camera_offset);
		STATES.CUTSCENE:
			rotation.y = goal_y_rot;
			rotation.x = deg_to_rad(top_tilt_limit);
		
	if goal_y_rot > rotation.y:
		rotation.y += deg_to_rad(camera_speed) * delta;
		rotation.y = minf(rotation.y, goal_y_rot);
	elif goal_y_rot < rotation.y:
		rotation.y -=  deg_to_rad(camera_speed) * delta;
		rotation.y = maxf(rotation.y, goal_y_rot);
