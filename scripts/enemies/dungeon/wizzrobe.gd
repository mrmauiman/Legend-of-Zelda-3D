class_name Wizzrobe extends Enemy

@onready var model = get_node("Model");
@onready var animation_player: AnimationPlayer = get_node("Model/TransparencyAnimationPlayer");
@onready var color_animation_player = get_node("Model/ColorAnimationPlayer");
@onready var bob_animation_player: AnimationPlayer = get_node("Model/AnimationPlayer");
@onready var health = get_node("Health");

@export var wait_time: float = 1;

const BEAM_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/wizzrobe_beam.tscn");

enum STATES {HIDDEN, APPEARING, ATTACKING, DISAPPEARING};

var state: STATES = STATES.HIDDEN;
var timer = wait_time;
var stun_timer: float = 0;



func attack():
	var location;
	var forward = -global_transform.basis.z;
	var forward_place = forward * 0.8;
	location = global_position + (Vector3.UP * 0.8) + forward_place;
	var beam = BEAM_SCENE.instantiate();
	beam.position = location;
	beam.direction = forward.normalized();
	beam.fire = false;
	get_tree().root.add_child(beam);
	SoundSystem.play("res://audio/sfx/MagicRod.wav", global_position);

func move_to_attack_pos():
	var link = Inventory.get_link();
	if not link: return;
	
	global_position = link.get_wizzrobe_spawn_position();
	var link_pos = link.global_position;
	link_pos.y = global_position.y;
	look_at(link_pos);

func _hidden_update(delta):
	timer -= delta;
	if timer <= 0:
		move_to_attack_pos();
		state = STATES.APPEARING;
		timer = wait_time;
		animation_player.play("appear");

func _attacking_update(delta):
	timer -= delta;
	if timer <= 0:
		state = STATES.DISAPPEARING;
		timer = wait_time;
		animation_player.play("disappear");

func _animation_finished(anim):
	if anim == "appear":
		state = STATES.ATTACKING;
		timer = wait_time;
		attack();
	elif anim == "disappear":
		state = STATES.HIDDEN;
		timer = wait_time;

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
	animation_player.animation_finished.connect(_animation_finished);
	animation_player.play_section("disappear", 1);
	
	model.has_bomb = false;
	model.has_compass = false;
	model.has_key = false;
	model.has_item = false;


func _physics_process(delta):
	if Inventory.clock_timer > 0 and stun_timer == 0:
		stun_timer = Inventory.clock_timer;
		animation_player.play_section("appear", 1);
		bob_animation_player.pause();
	if stun_timer > 0:
		stun_timer -= delta;
		if stun_timer <= 0:
			animation_player.play("disappear");
			bob_animation_player.play();
		return;
	match state:
		STATES.HIDDEN:
			_hidden_update(delta);
		STATES.ATTACKING:
			_attacking_update(delta);


func _on_hurt_box_area_entered(area):
	if area is HitBox and not area.is_magic:
		var hitbox: HitBox = area;
		color_animation_player.play("hurt");
		health.take_damage(hitbox.get_damage(false));
		hitbox.hit.emit(self);
		if hitbox.stun_time > 0:
			stun_timer = hitbox.stun_time;
			animation_player.play_section("appear", 1);
			bob_animation_player.pause();
		if health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
