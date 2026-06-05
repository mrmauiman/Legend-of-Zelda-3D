class_name Vire extends Enemy

# Components
@onready var state_machine: StateMachine = %StateMachine;
@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("%AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("%ColorAnimationPlayer");
@onready var health: Health = %Health;

const GRAVITY = 16;

func update_held_item():
	if held_item:
		var data = Randomizer.item_map[held_item];
		var type = data[0];
		var pickup = data[1];
		if type in ["sword_scroll", "compass", "map"]:
			pickup = type;
		match pickup:
			"bombs":
				model.has_bomb = true;
			"compass":
				model.has_compass = true;
			"keys":
				model.has_key = true;
			_:
				model.has_item = true;

func _ready():
	model.has_bomb = false;
	model.has_compass = false;
	model.has_key = false;
	model.has_item = false;


func play_hurt_animation():
	animation_player.play("hurt");
	color_animation_player.play("hurt");

func set_food(food):
	state_machine.change_state("Eat", food);

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();

func parried(_by):
	state_machine.change_state("Stunned", 1.5);

const RED_KEESE_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/red_keese.tscn");
const SPAWN_COUNT: int = 2;
func split():
	# Spawn 2 gel
	for i in range(SPAWN_COUNT):
		var keese = RED_KEESE_SCENE.instantiate();
		keese.position = position + Vector3.UP;
		get_parent().add_child(keese);
	
	var effect = ENEMY_DEATH_SCENE.instantiate();
	effect.position = global_position;
	get_tree().root.add_child(effect);
	SoundSystem.play("res://audio/sfx/EnemyDeath.wav", global_position);
	
	queue_free();
