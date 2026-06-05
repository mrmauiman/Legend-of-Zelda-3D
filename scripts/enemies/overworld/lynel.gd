@tool
extends Enemy

@export var turn_chance: int = 35;
@export var shoot_chance: int = 3;
@export var turn_frequency: float = 1;
@export var move_speed: float = 4.8;
@export var gravity: float = 10;
const TERMINAL_VELOCITY: float = -120;

@onready var model: Node3D = %LynelModel;
@onready var animation_player: AnimationPlayer = %LynelModel/AnimationPlayer;
@onready var hurt_animation_player: AnimationPlayer = %LynelModel/HurtAnimationPlayer
@onready var sight: Area3D = %Sight;
@onready var wall_checks: Node3D = %WallChecks;
@onready var link_sight_checker: RayCast3D = %LinkSightChecker;

enum STATES {MOVE, SHOOT, ALERTED, ATTACK, STUNNED, SPAWNING};
var state: STATES = STATES.SPAWNING;

var timer: float = turn_frequency;
var link;
var dir;

const LINK_PROXIMITY_NULLIFICATION: float = 4.8;

@onready var screen = get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = screen.get_node("SpawnChecker")

func spawned():
	state = STATES.MOVE;


func animation_finished(_anim):
	if state == STATES.SHOOT or state == STATES.ATTACK:
		if link:
			state = STATES.ALERTED;
		else:
			state = STATES.MOVE;
	if state == STATES.STUNNED:
		if link:
			state = STATES.ALERTED;
		else:
			state = STATES.MOVE;

func shoot():
	animation_player.play("shoot");
	state = STATES.SHOOT;
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
	var available = [Vector3.ZERO];
	for ray: ShapeCast3D in %WallChecks.get_children():
		if not ray.is_colliding():
			available.push_back(ray.target_position.normalized());
	if len(available) == 0: return dir;
	return available.pick_random();

func move_process(delta):
	# Get Movement Direction
	if is_on_wall() and get_wall_normal().angle_to(-dir) < deg_to_rad(45):
		dir = get_move_dir();
	timer -= delta;
	if timer <= 0:
		timer = turn_frequency;
		if randf_range(0, 100) < turn_chance:
			dir = get_move_dir();
	# Play corresponding animation
	if dir.length() > 0:
		animation_player.play("run");
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
		animation_player.play("run");
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

# BUILT INS

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

	wall_checks.position = global_position + Vector3(0, 0.8, 0);
	var grav_vec = Vector3.UP * max(velocity.y - gravity, TERMINAL_VELOCITY);
	
	if state == STATES.MOVE:
		move_process(delta);
	elif state == STATES.ALERTED:
		alerted_process(delta);
	elif state in [STATES.SHOOT, STATES.ATTACK, STATES.STUNNED]:
		var xz_vel = velocity;
		xz_vel.y = 0;
		xz_vel = xz_vel.lerp(Vector3.ZERO, delta * 3.2);
		velocity.x = xz_vel.x;
		velocity.z = xz_vel.z;
	
	velocity += grav_vec;
	move_and_slide();


# SIGNAL CONNECTIONS

func _on_hurt_box_area_entered(area):
	if area is HitBox:
		var hitbox: HitBox = area;
		hurt_animation_player.play("hurt");
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
		if hitbox.stun_time > 0:
			state = STATES.STUNNED;
			animation_player.play("stunned");
		%Health.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		if %Health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);

func parried(_by):
	state = STATES.STUNNED;
	hurt_animation_player.play("hurt");
	animation_player.play("stunned");


func update_held_item():
	pass
