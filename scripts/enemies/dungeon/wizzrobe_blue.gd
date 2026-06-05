class_name WizzrobeBlue extends Enemy

@onready var model: Node3D = get_node("Model");
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer");
@onready var transparency_animation_player: AnimationPlayer = model.get_node("TransparencyAnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("ColorAnimationPlayer");
@onready var health: Health = get_node("Health");
@onready var state_machine: StateMachine = get_node("StateMachine");
@onready var sight: Area3D = get_node("%Sight");

const GRAVITY: float = 64;
const BEAM_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/wizzrobe_beam.tscn");

@export var phase_check: float = 0.25;
@export var phase_chance: float = 5;
@export var attack_cooldown: float = 2.5;

var timer = phase_check;
var attack_timer = attack_cooldown;

func play_hurt_animation():
	color_animation_player.play("hurt");

func should_phase():
	return randf_range(0, 100) <= phase_chance;

func should_attack():
	return len(sight.get_overlapping_bodies()) > 0;

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
	transparency_animation_player.play("idle");
	
	model.has_bomb = false;
	model.has_compass = false;
	model.has_key = false;
	model.has_item = false;


func attack():
	var forward = global_transform.basis.z;
	var forward_place = forward * 0.8;
	var location = global_position + (Vector3.UP * 0.8) + forward_place;
	var beam = BEAM_SCENE.instantiate();
	beam.position = location;
	beam.direction = forward.normalized();
	beam.fire = false;
	beam.half_power = true;
	get_tree().root.add_child(beam);
	SoundSystem.play("res://audio/sfx/MagicRod.wav", global_position);
	attack_timer = attack_cooldown;

func extra_patrol_logic(delta):
	timer -= delta;
	if timer <= 0:
		if should_phase():
			state_machine.change_state("Phase");
		timer += phase_check;
	
	if attack_timer > 0:
		attack_timer -= delta;
	elif should_attack():
		attack();

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Patrol"):
		extra_patrol_logic(delta);

	if state_machine.current_state_is("Spawning"): return;

	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();
