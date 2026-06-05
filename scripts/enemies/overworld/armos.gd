extends Enemy

@onready var animation_player: AnimationPlayer = %ArmosModel/AnimationPlayer;
@onready var hurt_animation_player: AnimationPlayer = %ArmosModel/HurtAnimationPlayer;

#Sights
@onready var sight:Area3D = %Sight;
@onready var line_of_sight: RayCast3D = sight.get_node("RayCast3D");

@export var move_speed: float = 4.8;
## Chance out of 100 the armos will turn every second
@export_range(0, 100, 1) var turn_chance: float = 25;

enum STATES {SPAWNING, PATROL, CHASING, ATTACK, STUNNED};
var state: STATES = STATES.SPAWNING;

var dir: Vector3;
var timer: float = 1;
var link;
var blocking: bool = false;
var attack_speed: float = 1;
var stun_timer: float = 0;
var statue;

const GRAVITY = 64;


func update_held_item():
	pass

func check_sights():
	var bodies = sight.get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("Link"):
			line_of_sight.target_position = to_local(body.global_position + Vector3(0, 0.8, 0));
			if not line_of_sight.is_colliding():
				link = body;
				return;
	link = null;

func get_patrol_dir():
	var available = [];
	for ray: RayCast3D in %WallChecks.get_children():
		if not ray.is_colliding():
			available.push_back(ray.target_position.normalized());
	return available.pick_random();

func patrol_process(delta):
	animation_player.play("walk");
	if is_on_wall():
		dir = get_patrol_dir();
	
	timer -= delta;
	if timer <= 0:
		timer = 1;
		if randf_range(0, 100) < turn_chance:
			dir = get_patrol_dir();
	
	var move_vel = dir * move_speed;
	look_at(global_position - move_vel);
	velocity.x = move_vel.x;
	velocity.z = move_vel.z;
	
	check_sights();
	if link:
		state = STATES.CHASING;

func chasing_process(delta):
	check_sights();
	if not link:
		state = STATES.PATROL;
		return;
	
	var dir_vec = link.global_position - global_position;
	if dir_vec.length() > 1.9:
		animation_player.play("walk");
		dir_vec.y = 0;
		dir_vec = dir_vec.normalized();
		look_at(global_position - dir_vec);
		velocity.x = dir_vec.x * move_speed;
		velocity.z = dir_vec.z * move_speed;
		blocking = false;
		timer = randf_range(1, 5);
	else:
		velocity.x = 0;
		velocity.z = 0;
		animation_player.play("block");
		blocking = true;
		timer -= delta;
		if timer <= 0:
			blocking = false;
			animation_player.play("attack");
			state = STATES.ATTACK;
			attack_speed = randf_range(0.05, 1);

func _ready():
	animation_player.animation_finished.connect(_animation_finished);
	dir = get_patrol_dir();
	blocking = false;

func _physics_process(delta):
	
	if clock_stun: 
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;

	%WallChecks.position = global_position + Vector3(0, 0.8, 0);
	velocity.y -= GRAVITY * delta;
	
	match state:
		STATES.PATROL:
			patrol_process(delta);
		STATES.CHASING:
			chasing_process(delta);
		STATES.ATTACK:
			var anim_pos = animation_player.current_animation_position;
			if anim_pos >= 0.1 and anim_pos <= 0.3:
				animation_player.speed_scale = attack_speed;
			else:
				animation_player.speed_scale = 1;
		STATES.STUNNED:
			velocity.x = 0;
			velocity.z = 0;
			stun_timer -= delta;
			if stun_timer <= 0:
				check_sights();
				if link: 
					state = STATES.CHASING;
					timer = randf_range(1, 5);
				else: state = STATES.PATROL;
	
	move_and_slide();

func _animation_finished(anim):
	if state == STATES.SPAWNING and anim == "spawning":
		state = STATES.PATROL;
		dir = get_patrol_dir();
	
	if state == STATES.ATTACK and anim == "attack":
		check_sights();
		if link: 
			state = STATES.CHASING;
			timer = randf_range(1, 5);
		else: state = STATES.PATROL;
	if state == STATES.STUNNED and anim == "parried":
		check_sights();
		if link: 
			state = STATES.CHASING;
			timer = randf_range(1, 5);
		else: state = STATES.PATROL;


func _on_hurt_box_area_entered(area):
	if area is HitBox:
		var hitbox: HitBox = area;
		var knockback = hitbox.knockback;
		var attack_dir = knockback;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var kb_dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			kb_dir.y = 0;
			var xz_knockback = xz_speed * kb_dir.normalized();
			knockback = Vector3(xz_knockback.x, hitbox.knockback.y, xz_knockback.z);
			attack_dir = -knockback;
		elif hitbox.relative_knockback_orientor:
			var orientor_forward = -hitbox.relative_knockback_orientor.global_transform.basis.z;
			var orientor_right = hitbox.relative_knockback_orientor.global_transform.basis.x;
			knockback = (orientor_forward * knockback.z) + (orientor_right * knockback.x) + (Vector3.UP * knockback.y);
			if knockback.length() > 0:
				attack_dir = -knockback;
			else:
				attack_dir = orientor_forward;
		attack_dir.y = 0;
		attack_dir = attack_dir.normalized();
		if blocking and attack_dir.angle_to(global_transform.basis.z) < deg_to_rad(45):
			SoundSystem.play("res://audio/sfx/Blocked.wav", hitbox.global_position);
			return;
		
		hurt_animation_player.play("hurt");
		velocity = knockback;
		stun_timer = hitbox.stun_time;
		if stun_timer > 0:
			state = STATES.STUNNED;
		%Health.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		if %Health.is_dead():
			statue.queue_free();
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);

func parried():
	animation_player.play("parried");
	state = STATES.STUNNED;
	stun_timer = 10;

func _exit_tree():
	if statue:
		statue.appear();
