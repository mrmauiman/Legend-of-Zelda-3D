class_name Ganon extends CharacterBody3D

@onready var animation_player: AnimationPlayer = get_node("GanonModel/AnimationPlayer");
@onready var health: Health = get_node("Health");

@export var radius: float = 4;
@export var teleport_time: float = 2;

var teleport_timer: float = teleport_time;
var vulnerable = false;
var first = true;
var dead = false;

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/gleeok_fireball.tscn");
const TRIFORCE_SCENE: PackedScene = preload("res://scenes/pickups/triforce_of_power.tscn");

func update_held_item():
	pass;

func _animation_finished(anim):
	if anim == "vulnerable":
		vulnerable = false;
		health.health = health.max_health;
		_teleport();
		teleport_timer = teleport_time;
	elif anim == "death":
		var triforce_of_power = TRIFORCE_SCENE.instantiate();
		triforce_of_power.position = position;
		get_parent().add_child(triforce_of_power);
		queue_free();

func _shoot_fireball():
	var link = Inventory.get_link();
	if not link:
		return;
	var fireball = FIREBALL_SCENE.instantiate();
	var goal = link.global_position + (Vector3.UP * 0.8);
	fireball.position = global_position + (Vector3.UP * 0.8);
	fireball.direction = (goal-global_position).normalized();
	get_tree().root.add_child(fireball);

func _teleport(shoot=true):
	position = Vector3(radius, 0, 0).rotated(Vector3.UP, deg_to_rad(randf_range(0, 360)));
	look_at(Inventory.get_link().global_position);
	animation_player.play("pose"+str(randi_range(1, 5)));
	visible = false;
	if shoot:
		_shoot_fireball();

func die():
	dead = true;
	SoundSystem.play("res://audio/sfx/GanonDeath.wav", global_position);
	animation_player.play("death");

func _ready():
	animation_player.animation_finished.connect(_animation_finished);
	animation_player.play("pose2");
	look_at(Inventory.get_link().global_position);
	visible = true;
	await get_tree().create_timer(0.1, true).timeout;
	SoundSystem.play_global("res://audio/sfx/GanonRevealed.wav");
	Inventory.save_data(Inventory.current_slot);
	EnemyTracker.save_data(Inventory.current_slot);

var roar_timer: float = 2.5;
func _physics_process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = 2.5;
	if vulnerable: return;
	teleport_timer -= delta;
	if teleport_timer <= 0:
		if first:
			Inventory.get_link().engage_ganon();
			first = false;
			_teleport(false);
		else:
			_teleport();
		teleport_timer += teleport_time;


func _on_hurt_box_area_entered(area):
	if area is HitBox and not dead:
		if vulnerable and Inventory.items.arrow == Inventory.ITEM_TYPES.LVL2 and area.is_arrow:
			area.hit.emit(self);
			die();
		elif not vulnerable and area.is_sword and not visible:
			visible = true;
			health.take_damage(area.get_damage(false));
			area.hit.emit(self);
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
			if health.is_dead():
				vulnerable = true;
				animation_player.play("vulnerable");
