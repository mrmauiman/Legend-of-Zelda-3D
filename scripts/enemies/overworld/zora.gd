@tool
extends Node3D

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/overworld/zora_fireball.tscn");
const ENEMY_DEATH_SCENE: PackedScene = preload("res://scenes/enemies/death_effect.tscn");

@onready var water_checker: Node3D = %WaterChecker;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var sprites: Node3D = %Pivot;

@export var emerge_time: float = 1;
@export var drop_group: EnemyDrops.ENEMY_GROUPS;
@export var spawn_limit_min := Vector2(-12.8, -8.8);
@export var spawn_limit_max := Vector2(12.8, 8.8);

var timer: float = 0;
var starting_pos: Vector3;
var stun_timer: float = 0;

enum STATES {ABOVE_WATER, UNDER_WATER, ATTACK, HURT, STUNNED};
var state = STATES.UNDER_WATER;

var link = null;

var clock_stun: bool = false;

func in_water() -> bool:
	for check: Area3D in water_checker.get_children():
		if len(check.get_overlapping_bodies()) == 0:
			return false;
	return true;

func move():
	var pos = Vector3(randf_range(spawn_limit_min.x, spawn_limit_max.x), 0, randf_range(spawn_limit_min.y, spawn_limit_max.y));
	pos = (floor(pos/1.6) * 1.6) + Vector3(0.8, 0, 0);
	position = starting_pos + pos;

func shoot():
	var forward = sprites.global_transform.basis.z;
	forward.y = 0;
	forward = forward.normalized();
	var fire_ball = FIREBALL_SCENE.instantiate();
	fire_ball.position = global_position + (forward * 0.4) + (Vector3.UP * 0.7);
	fire_ball.direction = forward;
	get_tree().root.add_child(fire_ball);

func die():
	var effect = ENEMY_DEATH_SCENE.instantiate();
	effect.position = global_position;
	get_tree().root.add_child(effect);
	SoundSystem.play("res://audio/sfx/EnemyDeath.wav", global_position);
	
	# Spawn Drops
	var drop = EnemyDrops.get_drop(drop_group);
	EnemyDrops.spawn_drop(drop, global_position);
	
	queue_free();

func _ready():
	%Sight.global_position = global_position;
	if not Engine.is_editor_hint():
		starting_pos = position;

func _process(_delta):
	if Engine.is_editor_hint(): 
		return;
		

func _physics_process(delta):
	if Engine.is_editor_hint(): 
		%Sight.global_position = global_position;
		return;
	
	if Inventory.clock_timer > 0 and stun_timer <= 0 and state != STATES.STUNNED:
		if not in_water():
			move();
			return;
		stun_timer = Inventory.clock_timer;
		animation_player.play("stunned");
		state = STATES.STUNNED;

	match state:
		STATES.UNDER_WATER:
			if link:
				timer += delta;
				if timer >= emerge_time:
					if in_water():
						animation_player.play("emerge");
						state = STATES.ABOVE_WATER;
					else:
						move();
		STATES.STUNNED:
			if stun_timer > 0:
				stun_timer -= delta;
				if stun_timer <= 0:
					animation_player.play("disapear");
	if link and not state == STATES.STUNNED:
		sprites.look_at(global_position + (global_position-link.global_position));


func update_held_item():
	pass

func _on_animation_player_animation_finished(anim):
	if anim == "emerge":
		if not link:
			animation_player.play("disapear");
			state = STATES.ABOVE_WATER;
		else:
			animation_player.play("shoot");
			state = STATES.ATTACK;
	elif anim == "shoot":
		animation_player.play("disapear");
		state = STATES.ABOVE_WATER;
	elif anim == "disapear":
		state = STATES.UNDER_WATER;
		move();
		timer = 0;
	elif anim == "hurt":
		if stun_timer > 0:
			state = STATES.STUNNED;
			animation_player.play("stunned");
		else:
			state = STATES.ABOVE_WATER;
			animation_player.play("disapear");


func _on_sight_body_entered(body):
	if body.is_in_group("Link"):
		link = body;


func _on_sight_body_exited(body):
	if body.is_in_group("Link"):
		link = null;

func _on_hurt_box_area_entered(area):
	if area is HitBox and state != STATES.HURT:
		var hitbox: HitBox = area;
		state = STATES.HURT;
		animation_player.play("hurt");
		stun_timer = hitbox.stun_time;
		%Health.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		if %Health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
