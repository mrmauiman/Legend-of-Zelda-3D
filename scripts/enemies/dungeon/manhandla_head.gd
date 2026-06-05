extends CollisionShape3D

@onready var health: Health = get_node("Health");

@onready var manhandla: Manhandla = get_parent();
@onready var animation_player: AnimationPlayer = manhandla.get_node("Model/MouthColors");

@export var head_num: int = 0;
@export var shoot_chance: float = 40;
@export var min_shoot_interval: float = 1;
@export var max_shoot_interval: float = 10;

var shoot_timer: float = get_shoot_interval();

const FIREBALL: PackedScene = preload("res://scenes/enemies/dungeon/gleeok_fireball.tscn");

func get_shoot_interval() -> float:
	return randf_range(min_shoot_interval, max_shoot_interval);

func shoot():
	var fireball = FIREBALL.instantiate();
	fireball.direction = global_position.direction_to(Inventory.get_link().global_position + Vector3(0, 0.8, 0));
	fireball.position = global_position;
	get_tree().root.add_child(fireball);

func _process(delta):
	shoot_timer -= delta;
	if shoot_timer <= 0:
		if randf_range(0, 100) < shoot_chance:
			shoot();
		shoot_timer = get_shoot_interval();

func _on_hurtbox_enter(other: Area3D):
	if other is HitBox:
		health.take_damage(other.get_damage())
		other.hit.emit(self);
		animation_player.play("hurt"+str(head_num+1));
		SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
		if health.is_dead():
			manhandla.heads[head_num] = false;
			manhandla.check_dead();
			queue_free();
