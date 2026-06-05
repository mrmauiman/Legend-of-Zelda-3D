extends Enemy

@export var attack_freq: float = 0.35;
@export var attack_cooldown: float = 1.0;
@export var attack_chance: float = 15; # Chance out of 100 the gleeok attacks every attack_freq seconds

@onready var state_machine: StateMachine = %StateMachine;

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/gleeok_fireball.tscn");

var timer: float = attack_freq;
var animation_player = false;

func update_held_item():
	pass;

func fire():
	var link = Inventory.get_link();
	if not link:
		return;
	var fireball = FIREBALL_SCENE.instantiate();
	var goal = link.global_position + (Vector3.UP * 0.8);
	fireball.position = global_position;
	fireball.direction = (goal-global_position).normalized();
	get_tree().root.add_child(fireball);


func should_attack() -> bool:
	return randf_range(0, 100) < attack_chance;

func _process(delta):
	timer -= delta;
	if timer <= 0:
		timer = attack_freq;
		if should_attack():
			fire();

func _physics_process(_delta):

	move_and_slide();
