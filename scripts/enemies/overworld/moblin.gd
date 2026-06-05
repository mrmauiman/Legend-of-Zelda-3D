@tool
extends Enemy

@export var turn_chance: int = 50;
@export var shoot_chance: int = 3;
@export var turn_frequency: float = 1;
@export var move_speed: float = 4.8;
@export var gravity: float = 10;
const TERMINAL_VELOCITY: float = -120;

@onready var model: Node3D = %MoblinModel;
@onready var animation_player: AnimationPlayer = %MoblinModel/AnimationPlayer;
@onready var sight: Area3D = %Sight;
@onready var wall_checks: Node3D = %WallChecks;
@onready var link_sight_checker: RayCast3D = %LinkSightChecker;

enum STATES {MOVE, THROW, ALERTED, ATTACK, HURT, STUNNED, SPAWNING};
var state: STATES = STATES.SPAWNING;

var timer: float = turn_frequency;
var stun_timer: float = 0;
var link;
var dir = Vector3.ZERO;
var food;

const LINK_PROXIMITY_NULLIFICATION: float = 4.8;

@onready var screen = get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = screen.get_node("SpawnChecker")



func update_held_item():
	pass

func spawned():
	state = STATES.MOVE;

func animation_finished(_anim):
	if state == STATES.THROW or state == STATES.ATTACK:
		if link:
			state = STATES.ALERTED;
		else:
			state = STATES.MOVE;
	if state == STATES.HURT:
		if stun_timer > 0:
			velocity = Vector3.ZERO;
			state = STATES.STUNNED;
		elif link:
			state = STATES.ALERTED;
		else:
			state = STATES.MOVE;

func shoot():
	animation_player.play("throw");
	state = STATES.THROW;
	velocity = Vector3.UP * velocity.y;

func attack():
	animation_player.play("attack");
	state = STATES.ATTACK;
	velocity = Vector3.UP * velocity.y;

func check_sights():
	var bodies = sight.get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("Link"):
			link_sight_checker.target_position = to_local(body.global_position + Vector3(0, 0.8, 0));
			if not link_sight_checker.is_colliding():
				link = body;
				return;
	link = null;

func get_move_dir():
	var available = [];
	if dir and dir.length() > 0: available.push_back(Vector3.ZERO);
	for ray: ShapeCast3D in %WallChecks.get_children():
		if not ray.is_colliding():
			available.push_back(ray.target_position.normalized());
	if len(available) == 0: return dir;
	return available.pick_random();

func move_process(delta):
	# Get Movement Direction
	if is_on_wall():
		dir = get_move_dir();
	timer -= delta;
	if timer <= 0:
		timer = turn_frequency;
		if randf_range(0, 100) < turn_chance:
			dir = get_move_dir();
	# Play corresponding animation
	if dir.length() > 0:
		animation_player.play("walk");
	else:
		animation_player.play("idle");
	
	var move_vel = dir * move_speed;
	if dir.length() > 0:
		look_at(global_position + move_vel);
	velocity.x = move_vel.x;
	velocity.z = move_vel.z;
	
	check_sights();
	if link:
		state = STATES.ALERTED;
	

func alerted_process(delta):
	check_sights();
	if not link: 
		state = STATES.MOVE;
		return;
	
	var dir_vec = link.global_position - global_position;
	if dir_vec.length() > 1.6:
		animation_player.play("walk");
		dir_vec.y = 0;
		dir_vec = dir_vec.normalized();
		look_at(global_position + dir_vec);
		velocity.x = dir_vec.x * move_speed;
		velocity.z = dir_vec.z * move_speed;
		timer -= delta;
		if timer <= 0:
			if randi_range(1, shoot_chance)  == shoot_chance:
				shoot();
			timer = turn_frequency;
	else:
		velocity = Vector3(0, velocity.y, 0);
		animation_player.play("idle");
		timer -= delta;
		if timer <= 0:
			attack();
			timer = turn_frequency;
	
	%LinkSightChecker.target_position = to_local(link.global_position);
	if %LinkSightChecker.is_colliding():
		set_deferred("link", null);

func food_process(delta):
	var dist_to_food = global_position.distance_to(food.global_position);
	if dist_to_food < 1:
		velocity.x = 0;
		velocity.z = 0;
		animation_player.play("eat");
		food.take_bite(delta);
	else:
		var dir_to_food = food.global_position - global_position;
		dir_to_food.y = 0;
		velocity = dir_to_food.normalized() * move_speed;
	var food_pos = food.global_position;
	food_pos.y = global_position.y;
	look_at(food_pos);

func set_food(p_food):
	food = p_food;

func _ready():
	animation_player.animation_finished.connect(animation_finished);
	dir = get_move_dir();

func _physics_process(delta):
	%WallChecks.position = global_position + Vector3(0, 0.8, 0);
	if Engine.is_editor_hint():
		return;
	
	if state == STATES.SPAWNING: return;
	
	if clock_stun: 
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;

	var grav_vec = Vector3.UP * max(velocity.y - gravity, TERMINAL_VELOCITY);
	
	if food and not state in [STATES.HURT, STATES.STUNNED]:
		food_process(delta);
	elif state == STATES.MOVE:
		move_process(delta);
	elif state == STATES.ALERTED:
		alerted_process(delta)
	elif state == STATES.STUNNED:
		stun_timer = max(stun_timer - delta, 0);
		if stun_timer == 0:
			state = STATES.MOVE;
	
	velocity += grav_vec;
	move_and_slide();


func _on_hurt_box_area_entered(area):
	if area is HitBox and state != STATES.HURT:
		var hitbox: HitBox = area;
		state = STATES.HURT;
		animation_player.play("hurt");
		var knockback = hitbox.knockback;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var kb_dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			kb_dir.y = 0;
			var xz_knockback = xz_speed * kb_dir.normalized();
			knockback = Vector3(xz_knockback.x, hitbox.knockback.y, xz_knockback.z);
		elif hitbox.relative_knockback_orientor:
			var orientor_forward = -hitbox.relative_knockback_orientor.global_transform.basis.z;
			var orientor_right = hitbox.relative_knockback_orientor.global_transform.basis.x;
			knockback = (orientor_forward * knockback.z) + (orientor_right * knockback.x) + (Vector3.UP * knockback.y);
		velocity = knockback;
		stun_timer = hitbox.stun_time;
		%Health.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		if %Health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);

func blocked(_by):
	state = STATES.STUNNED;
	velocity = (global_transform.basis.z * move_speed) + (Vector3.UP * move_speed);
	stun_timer = 0.5;

func parried(_by):
	state = STATES.HURT;
	animation_player.play("hurt");
	velocity = (global_transform.basis.z * move_speed*2) + (Vector3.UP * move_speed*2);
	stun_timer = 1;
