extends CharacterBody3D

@export var move_speed: float = 5;
@export var gravity: float = -64;
@export var i_seconds: float = 1;

@onready var camera: Camera3D = %Camera3D;
@onready var model: Node3D = %LinkModel;
@onready var animation_player: AnimationPlayer = %LinkModel/AnimationPlayer;
@onready var color_animation_player: AnimationPlayer = %LinkModel/ColorAnimationPlayer;
@onready var pickup_sprite: Sprite3D = %LinkModel.get_node("%Pickup");
@onready var collision_shape: CollisionShape3D = $CollisionShape3D;
@onready var on_top_display_viewport: SubViewport = %OnTopDisplayViewPort;

const TERMINAL_VELOCITY: float = -120;
const FAIRY_TIME: float = 2;

enum STATES {MOVE, ATTACK, ROLL, BLOCK, PARRY, BOOMERANG, BOMB, BOW, CANDLE, FLUTE, FOOD, LETTER, POTION, MAGIC_ROD, RAFT, HURT, PICKUP, PUSH, FAIRY_HEALING, GRABBED, TRIFORCE_PICKUP, ENDING_CUTSCENE, DEAD};
var state: STATES = STATES.MOVE;

var input: Vector2 = Vector2.ZERO;

var attack_counter: int = 0;
var buffer_attack: bool = false;
var boomerang_thrown = false;
var i_seconds_timer: float = 0;
var pushing: StaticBody3D;
var dist_pushed: float = 0;
var push_dir: Vector3;
var curse_timer: float = 0;
var flute_input_used: bool = false;

signal show_letter;

func aligned_input(vec: Vector2):
	if input.length() == 0: return false;
	var forward_vec = -camera.global_transform.basis.z;
	forward_vec.y = 0;
	forward_vec = Vector2(forward_vec.x, -forward_vec.z).normalized();
	var input_vec = (forward_vec * input.y) + (forward_vec.orthogonal() * input.x);
	var forward_v3 = model.transform.basis.z;
	var forward_v2 = Vector2(forward_v3.x, -forward_v3.z).normalized();
	var check_vec = (vec.x * forward_v2.orthogonal()) + (vec.y * forward_v2);
	return abs(input_vec.angle_to(check_vec)) < deg_to_rad(45);

func forward_input():
	return aligned_input(Vector2(0, 1));

func get_attack_anim():
	if forward_input():
		return "thrust";
	elif Input.is_action_pressed("target"):
		return "v_slash";
	return "h_slash";

func get_finisher_attack_anim():
	if forward_input():
		return "h_slash_finisher";
	elif Input.is_action_pressed("target"):
		return "v_slash_finisher";
	return "thrust_finisher";

func animation_finished(anim):
	if state == STATES.ATTACK:
		var vel = Vector3(velocity.x, 0, velocity.z);
		if anim == "charge_spin":
			animation_player.play("charged_spin");
			SoundSystem.play("res://audio/sfx/RupeeDecreaseEnding.ogg", global_position);
			return;
		if anim == "block_stab" and Input.is_action_pressed("shield"):
			state = STATES.BLOCK;
			animation_player.play("block");
		if vel.length() > 0:
			velocity.x = 0;
			velocity.z = 0;
			if buffer_attack:
				animation_player.play("thrust_finisher");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				attack_counter = 0;
				buffer_attack = false;
				return;
		if hold_attack and not buffer_attack:
			animation_player.play("charge_spin");
			SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
		elif buffer_attack and attack_counter > 0:
			if attack_counter < 3:
				animation_player.play(get_attack_anim());
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				attack_counter += 1;
			else:
				animation_player.play(get_finisher_attack_anim());
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				attack_counter = 0;
		else:
			state = STATES.MOVE;
		buffer_attack = false;
	elif state == STATES.ROLL:
		if hop_roll and aligned_input(Vector2(1, 0)):
			animation_player.play("roll_right");
			hop_roll = false;
		elif hop_roll and aligned_input(Vector2(-1, 0)):
			animation_player.play("roll_left");
			hop_roll = false;
		elif buffer_attack:
			var has_roll_attack = Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.ROLL_ATTACK];
			var has_bakflip_attack = Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.BACK_FLIP_ATTACK];
			if anim == "roll" and has_roll_attack:
				animation_player.play("thrust");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				attack_counter += 1;
				state = STATES.ATTACK;
				#velocity = velocity * 0.5;
			elif anim  in ["roll_right", "roll_left", "r_side_hop", "l_side_hop"] and has_roll_attack:
				animation_player.play("thrust_finisher");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				attack_counter = 0;
				state = STATES.ATTACK;
				velocity.x = 0;
				velocity.z = 0;
			elif anim in ["back_flip"] and has_bakflip_attack:
				animation_player.play("thrust_finisher");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				attack_counter = 0;
				state = STATES.ATTACK;
				var vel_y = velocity.y;
				velocity = get_forward() * move_speed * 3;
				velocity.y = vel_y;
			else:
				state = STATES.MOVE;
			buffer_attack = false;
		else:
			state = STATES.MOVE;
	elif state == STATES.PARRY:
		if Input.is_action_pressed("shield"):
			state = STATES.BLOCK;
			animation_player.play("block");
		else:
			state = STATES.MOVE;
	elif state == STATES.BOOMERANG:
		state = STATES.MOVE;
	elif state == STATES.BOMB and anim == "throw_bomb":
		state = STATES.MOVE;
	elif state == STATES.BOMB and anim == "put_away_bomb":
		Inventory.counters.bombs = min(Inventory.counters.bombs+1, Inventory.counter_maxes.bombs);
		state = STATES.MOVE;
	elif state == STATES.BOW:
		state = STATES.MOVE;
	elif state == STATES.CANDLE:
		state = STATES.MOVE;
	elif state == STATES.FLUTE:
		get_tree().paused = false;
		Inventory.recorded_played.emit();
		animation_player.process_mode = Node.PROCESS_MODE_INHERIT;
		if not flute_input_used: flute_teleport();
		state = STATES.MOVE;
	elif state == STATES.FOOD and anim == "throw_food":
		state = STATES.MOVE;
	elif state == STATES.FOOD and anim == "put_away_food":
		Inventory.counters.food = min(Inventory.counters.food+1, Inventory.counter_maxes.food);
		state = STATES.MOVE;
	elif state == STATES.LETTER:
		state = STATES.MOVE;
	elif state == STATES.POTION:
		Inventory.items.potion -= 1;
		Inventory.health = Inventory.get_max_health();
		state = STATES.MOVE;
	elif state == STATES.MAGIC_ROD:
		state = STATES.MOVE;
	elif state == STATES.HURT:
		i_seconds_timer = i_seconds;
		state = STATES.MOVE;
	elif state == STATES.PICKUP:
		state = STATES.MOVE;
	elif state == STATES.TRIFORCE_PICKUP:
		get_tree().change_scene_to_file("res://scenes/chunked_worlds/overworld/overworld.tscn");
	elif state == STATES.DEAD:
		model.visible = false;
		var effect = load("res://scenes/enemies/death_effect.tscn").instantiate();
		effect.position = model.global_position;
		model.get_parent().add_child(effect);
		PauseMenu.get_node("MarginContainer")._on_save_button_pressed();

func use_item(item):
	if Inventory.items[item] == Inventory.ITEM_TYPES.NONE: return;
	match item:
		"boomerang":
			if not boomerang_thrown and animation_player.current_animation != "throw_boomerang":
				state = STATES.BOOMERANG;
				animation_player.play("throw_boomerang");
				velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		"bomb":
			if Inventory.counters.bombs > 0:
				state = STATES.BOMB;
				animation_player.play("hold_bomb");
				Inventory.counters.bombs -= 1;
		"bow":
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
			state = STATES.BOW;
			animation_player.play("fire_bow");
		"candle":
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
			state = STATES.CANDLE;
			animation_player.play("light");
		"recorder":
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
			flute_input_used = false;
			state = STATES.FLUTE;
			animation_player.process_mode = Node.PROCESS_MODE_ALWAYS;
			animation_player.play("play_flute");
			SoundSystem.play("res://audio/sfx/RecorderSound.wav", global_position);
			get_tree().paused = true;
		"food":
			if Inventory.counters.food > 0:
				state = STATES.FOOD;
				animation_player.play("hold_food");
				Inventory.counters.food -= 1;
		"letter":
			if Inventory.items.letter == Inventory.ITEM_TYPES.LVL2:
				use_item("potion");
				return;
			state = STATES.LETTER;
			animation_player.play("present_letter");
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
			show_letter.emit();
		"potion":
			state = STATES.POTION;
			animation_player.play("drink_potion");
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		"magic_rod":
			state = STATES.MAGIC_ROD;
			animation_player.play("magic_rod");
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);

const RAFT_SCENE: PackedScene = preload("res://scenes/link/raft.tscn");
const STEP_LADDER_SCENE: PackedScene = preload("res://scenes/link/step_ladder.tscn");
var step_ladder;
var raft;

func start_raft(dir: Vector3, center_x: float):
	raft = RAFT_SCENE.instantiate();
	var pos = global_position;
	pos.x = center_x;
	pos.y = 0;
	raft.position = pos + (dir * 1.6) + (Vector3.DOWN * 0.3);
	raft.direction = dir;
	get_tree().root.add_child(raft);
	velocity = Vector3.ZERO;
	state = STATES.RAFT;
	animation_player.play("idle");
	raft.dismount.connect(dismount);
	%CollisionShape3D.set_deferred("disabled", true);
	$HurtBox/CollisionShape3D.set_deferred("disabled", true);
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");

func dismount():
	position += (raft.direction * 1.6) + (Vector3.UP * 1.2);
	raft.queue_free();
	state = STATES.MOVE;
	%CollisionShape3D.set_deferred("disabled", false);
	$HurtBox/CollisionShape3D.set_deferred("disabled", false);

func _ready():
	animation_player.animation_finished.connect(animation_finished);
	Inventory.link = self;
	camera.current = true;

var hold_attack = false;

func should_hop_roll() -> bool:
	if state == STATES.ROLL:
		if animation_player.current_animation == "r_side_hop" and aligned_input(Vector2(1, 0)):
			return true;
		elif animation_player.current_animation == "l_side_hop" and aligned_input(Vector2(-1, 0)):
			return true;
	return false;

var hop_roll: bool = false;

func _process(delta):
	if state == STATES.FAIRY_HEALING:
		animation_player.play("idle");
		return;
	
	if i_seconds_timer > 0: 
		i_seconds_timer -= delta;
		if color_animation_player.current_animation != "hurt":
			color_animation_player.play("hurt");
	elif color_animation_player.current_animation == "hurt" and state != STATES.HURT:
		color_animation_player.play("normal");
	
	if curse_timer > 0:
		curse_timer -= delta;
	
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	input.y = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward");
	#print(input.length());
	if Input.is_action_just_pressed("attack") and curse_timer <= 0:
		hold_attack = true;
		if state == STATES.ATTACK:
			buffer_attack = true;
		elif state == STATES.ROLL and Inventory.items.sword != Inventory.ITEM_TYPES.NONE:
			buffer_attack = true;
			attack_counter = 2;
		elif state == STATES.MOVE and Inventory.items.sword != Inventory.ITEM_TYPES.NONE:
			state = STATES.ATTACK;
			if spin_input:
				animation_player.play("thrust_finisher");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
			else:
				animation_player.play(get_attack_anim());
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
			attack_counter = 1;
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		elif state == STATES.BOMB:
			animation_player.play("put_away_bomb");
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		elif state == STATES.FOOD:
			animation_player.play("put_away_food");
			velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		elif state == STATES.BLOCK and Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.SHIELD_STAB] and Inventory.items.sword != Inventory.ITEM_TYPES.NONE:
			state = STATES.ATTACK;
			animation_player.play("block_stab");
			SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
			attack_counter = 0;
	
	if Input.is_action_just_released("attack"):
		hold_attack = false;
		var anim = animation_player.current_animation;
		if anim == "charge_spin" or (anim == "charged_spin" and not Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.GREAT_SPIN_ATTACK]):
			animation_player.play("thrust_finisher");
			SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
		elif anim == "charged_spin" and Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.GREAT_SPIN_ATTACK]:
			animation_player.play("great_spin_attack");
			SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
	
	Inventory.current_context = Inventory.CONTEXT_ACTIONS.NONE;
	
	if state == STATES.MOVE:
		if Input.is_action_pressed("target") and (forward_input() or input.length() == 0) and Inventory.items.sword > Inventory.ITEM_TYPES.NONE:
			Inventory.current_context = Inventory.CONTEXT_ACTIONS.JUMP_ATTACK;
		elif input.length() > 0:
			if forward_input() or not Input.is_action_pressed("target"):
				Inventory.current_context = Inventory.CONTEXT_ACTIONS.ROLL;
			else:
				Inventory.current_context = Inventory.CONTEXT_ACTIONS.JUMP;
	
	if Input.is_action_pressed("shield") and state == STATES.MOVE:
		state = STATES.BLOCK;
		velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		animation_player.play("block");
	elif not Input.is_action_pressed("shield") and state == STATES.BLOCK:
		state = STATES.MOVE;
	
	if state == STATES.BLOCK:
		Inventory.current_context = Inventory.CONTEXT_ACTIONS.PARRY;
	
	if state == STATES.MOVE:
		if Input.is_action_just_pressed("item_1") and Inventory.item_slots.item_1 != "":
			use_item(Inventory.item_slots.item_1);
		if Input.is_action_just_pressed("item_2") and Inventory.item_slots.item_2 != "":
			use_item(Inventory.item_slots.item_2);
		if Input.is_action_just_pressed("item_3") and Inventory.item_slots.item_3 != "":
			use_item(Inventory.item_slots.item_3);
	
	if state == STATES.BOMB or state == STATES.FOOD:
		if input.length() == 0:
			Inventory.current_context = Inventory.CONTEXT_ACTIONS.PLACE;
		else:
			Inventory.current_context = Inventory.CONTEXT_ACTIONS.THROW;

	if Input.is_action_just_pressed("action") and state != STATES.HURT and is_on_floor():
		if should_hop_roll():
			hop_roll = true;
		if Inventory.current_context == Inventory.CONTEXT_ACTIONS.JUMP_ATTACK:
			if can_helm_splitter() and curse_timer <= 0:
				state = STATES.ATTACK;
				animation_player.play("jump_over_attack");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				velocity = get_forward() * move_speed * 2;
				velocity.y = 19;
			elif curse_timer <= 0:
				state = STATES.ATTACK;
				animation_player.play("v_slash_finisher");
				SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
				var forward_vec = model.global_transform.basis.z;
				forward_vec.y = 0;
				forward_vec = forward_vec.normalized();
				velocity = forward_vec * move_speed * 2;
		elif Inventory.current_context == Inventory.CONTEXT_ACTIONS.ROLL or Inventory.current_context == Inventory.CONTEXT_ACTIONS.JUMP:
			velocity = velocity * 2;
			state = STATES.ROLL;
			if aligned_input(Vector2(0, 1)) and Inventory.current_context == Inventory.CONTEXT_ACTIONS.ROLL:
				animation_player.play("roll");
				SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);
			elif aligned_input(Vector2(0, -1)):
				animation_player.play("back_flip");
				SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);
			elif aligned_input(Vector2(1, 0)):
				if Inventory.current_context == Inventory.CONTEXT_ACTIONS.ROLL:
					animation_player.play("roll_right");
				animation_player.play("r_side_hop");
				SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);
			elif aligned_input(Vector2(-1, 0)):
				if Inventory.current_context == Inventory.CONTEXT_ACTIONS.ROLL:
					animation_player.play("roll_left");
				animation_player.play("l_side_hop");
				SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);
		elif Inventory.current_context == Inventory.CONTEXT_ACTIONS.PARRY:
			state = STATES.PARRY;
			animation_player.play("parry");
			SoundSystem.play("res://audio/sfx/LinkJump.wav", global_position);
		elif Inventory.current_context == Inventory.CONTEXT_ACTIONS.PLACE or Inventory.current_context == Inventory.CONTEXT_ACTIONS.THROW:
			if state == STATES.BOMB:
				animation_player.play("throw_bomb");
				velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
			elif state == STATES.FOOD:
				animation_player.play("throw_food");
				velocity = Vector3.DOWN * abs(TERMINAL_VELOCITY);
		elif Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.RISING_SPIN_ATTACK] and input.length() == 0 and curse_timer <= 0 and Inventory.items.sword != Inventory.ITEM_TYPES.NONE:
			state = STATES.ATTACK;
			animation_player.play("thrust_finisher");
			SoundSystem.play("res://audio/sfx/SwordSwing.wav", global_position);
			velocity.x = 0;
			velocity.z = 0;
			velocity.y = 16;


var input_stick_buffer: Array[Vector2] = [];
var spin_input: bool = false;
const SPIN_INPUT_LENGTH: float = 0.25;
var spin_input_timer: float = 0;

func print_stick_buffer():
	var out = []
	for i in range(len(input_stick_buffer)-1):
		out.push_back(rad_to_deg(input_stick_buffer[i].angle_to(input_stick_buffer[i+1])));
	print(out);

func check_for_spin_input():
	var total = 0;
	for i in range(len(input_stick_buffer)-1):
		total += abs(rad_to_deg(input_stick_buffer[i].angle_to(input_stick_buffer[i+1])));
	if total >= 360:
		spin_input = true;
		spin_input_timer = 0;

var move_dir: Vector3;

func _physics_process(delta):
	if state in [STATES.FAIRY_HEALING, STATES.GRABBED]: return;
	var forward_vec = -camera.global_transform.basis.z;
	forward_vec.y = 0;
	forward_vec = forward_vec.normalized();
	var right_vec = camera.global_transform.basis.x;
	right_vec.y = 0;
	right_vec = right_vec.normalized();
	var adjusted_input = (input.y * forward_vec) + (input.x * right_vec);
	move_dir = adjusted_input.normalized();
	var y_vel = Vector3(0, velocity.y, 0);
	
	if spin_input:
		spin_input_timer += delta;
		if spin_input_timer >= SPIN_INPUT_LENGTH:
			spin_input = false;
	
	if state == STATES.MOVE:
		velocity = (adjusted_input * move_speed) + y_vel;
		if move_dir.length() > 0:
			if not Input.is_action_pressed("target"):
				model.look_at(model.global_position - move_dir);
			animation_player.play("walk");
			if is_on_wall():
				var collision: KinematicCollision3D = move_and_collide((velocity * delta), true);
				if collision:
					var test_step: KinematicCollision3D = move_and_collide((velocity * delta) + Vector3(0, 0.15, 0), true);
					if not test_step:
						move_and_collide((velocity * delta) + Vector3(0, 0.15, 0), false);
		else:
			animation_player.play("idle");
		if input.length() > 0:
			if len(input_stick_buffer) > 1:
				var prev_dir = rad_to_deg(input_stick_buffer[1].angle_to(input_stick_buffer[0]));
				var curr_dir = rad_to_deg(input_stick_buffer[0].angle_to(input));;
				if (sign(prev_dir) != sign(curr_dir) and prev_dir != 0 and curr_dir != 0):
					input_stick_buffer = [];
			if len(input_stick_buffer) == 0 or input != input_stick_buffer[0]:
				input_stick_buffer.push_front(input);
			check_for_spin_input();
		else:
			input_stick_buffer = [];
	
	if state == STATES.ATTACK and animation_player.current_animation == "v_slash_finisher":
		if animation_player.current_animation_position > 0.2:
			velocity.x = 0;
			velocity.z = 0;
	
	if state == STATES.ATTACK and animation_player.current_animation == "jump_over_attack":
		var vel = get_forward() * move_speed * 2;
		velocity.x = vel.x;
		velocity.z = vel.z;
	
	if state == STATES.BOMB and not animation_player.current_animation in ["throw_bomb", "put_away_bomb"]:
		velocity = (adjusted_input * move_speed) + y_vel;
		if move_dir.length() > 0:
			if not Input.is_action_pressed("target"):
				model.look_at(model.global_position - move_dir);
			animation_player.play("hold_walk");
		else:
			animation_player.play("hold_bomb");
	
	if state == STATES.FOOD and not animation_player.current_animation in ["throw_food", "put_away_food"]:
		velocity = (adjusted_input * move_speed) + y_vel;
		if move_dir.length() > 0:
			if not Input.is_action_pressed("target"):
				model.look_at(model.global_position - move_dir);
			animation_player.play("hold_walk");
		else:
			animation_player.play("hold_food");
	
	if state == STATES.BLOCK:
		if move_dir.length() > 0 and not Input.is_action_pressed("target"):
			model.look_at(model.global_position - move_dir);
	
	if state == STATES.RAFT:
		position = raft.position + (Vector3.UP * 0.2);
		return;
	
	if state == STATES.HURT:
		if is_on_floor() and y_vel.y < 0:
			velocity = Vector3.UP * y_vel;
	
	if state == STATES.PUSH:
		velocity = push_dir * (move_speed/2);
		var amount = velocity.length() * delta
		if dist_pushed + amount > 1.6:
			amount = 1.6 - dist_pushed;
		pushing.move_and_collide(velocity * delta);
		dist_pushed += amount;
		if dist_pushed >= 1.6:
			pushing.handle_pushed();
			state = STATES.MOVE;
	
	if state == STATES.ROLL:
		if animation_player.current_animation in ["roll_right", "roll_left", "r_side_hop", "l_side_hop"]:
			var camera_pivot = %CameraPivot;
			if camera_pivot.has_target():
				velocity = camera_pivot.get_target_tangent(velocity, animation_player.current_animation);

	if state == STATES.BLOCK:
		const FRICTION: float = 12.8;
		var temp = velocity;
		temp.y = 0;
		temp = temp.normalized() * max(temp.length() - (FRICTION * delta), 0);
		velocity.x = temp.x;
		velocity.z = temp.z;
	
	if state == STATES.ENDING_CUTSCENE and animation_player.current_animation == "pickup_triforce_piece":
		model.look_at(global_position + Vector3(0, 0, 1));

	var grav_vel = max(velocity.y + (gravity * delta), TERMINAL_VELOCITY);
	velocity.y = grav_vel;
	
	move_and_slide();
	
	if state == STATES.MOVE and Inventory.items.step_ladder != Inventory.ITEM_TYPES.NONE and not step_ladder and is_on_floor():
		var collision_count = get_slide_collision_count();
		for i in range(collision_count):
			var collision: KinematicCollision3D = get_slide_collision(i);
			if collision.get_collider().is_in_group("Water"):
				var pos = collision.get_position();
				var forward = collision.get_normal() * -1;
				pos.y = global_position.y;
				step_ladder = STEP_LADDER_SCENE.instantiate();
				if abs(forward.x) > 0: step_ladder.rotation_degrees.y = 90;
				step_ladder.position = pos + (forward * 0.8);
				get_tree().root.add_child(step_ladder);


func _on_hurt_box_area_entered(area):
	if area is HitBox and state != STATES.HURT and state != STATES.PICKUP and state != STATES.DEAD and i_seconds_timer <= 0 and Inventory.clock_timer <= 0:
		var hitbox: HitBox = area;
		var knockback = hitbox.knockback;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			dir.y = 0;
			var xz_knockback = xz_speed * dir.normalized();
			knockback = Vector3(xz_knockback.x, hitbox.knockback.y, xz_knockback.z);
		elif hitbox.relative_knockback_orientor:
			var orientor_forward = -hitbox.relative_knockback_orientor.global_transform.basis.z;
			var orientor_right = hitbox.relative_knockback_orientor.global_transform.basis.x;
			knockback = (orientor_forward * knockback.z) + (orientor_right * knockback.x) + (Vector3.UP * knockback.y);
		var knockback_dir = knockback;
		knockback_dir.y = 0;
		knockback_dir = knockback_dir.normalized();
		
		match state:
			STATES.BOMB:
				Inventory.counters.bombs = min(Inventory.counters.bombs+1, Inventory.counter_maxes.bombs);
			STATES.FOOD:
				Inventory.counters.food = min(Inventory.counters.food+1, Inventory.counter_maxes.food);
			STATES.BLOCK:
				if abs((-model.global_transform.basis.z).angle_to(knockback_dir)) < deg_to_rad(45):
					if not hitbox.is_magic or Inventory.items.shield == Inventory.ITEM_TYPES.LVL2:
						SoundSystem.play("res://audio/sfx/Blocked.wav", hitbox.global_position);
						hitbox.blocked.emit(self);
						velocity = knockback/2;
						return;
			STATES.PARRY:
				if abs((-model.global_transform.basis.z).angle_to(knockback_dir)) < deg_to_rad(45) and animation_player.current_animation_position < 0.1:
					if not hitbox.is_magic or Inventory.items.shield == Inventory.ITEM_TYPES.LVL2:
						SoundSystem.play("res://audio/sfx/Blocked.wav", hitbox.global_position);
						SoundSystem.play("res://audio/sfx/RupeePickup.wav", hitbox.global_position);
						hitbox.parried.emit(self);
						return;
		
		
		velocity = knockback;
		curse_timer = hitbox.curse_time;
		if not hitbox.no_stun:
			state = STATES.HURT;
			animation_player.play("hurt");
			color_animation_player.play("hurt");
		Inventory.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		SoundSystem.play("res://audio/sfx/PlayerHurt.wav", global_position);
		if Inventory.is_dead():
			die();

func die():
	velocity = Vector3.ZERO;
	model.reparent(on_top_display_viewport, true);
	animation_player.play("die");
	SoundSystem.play_game_over_music();
	state = STATES.DEAD;
	Inventory.deaths += 1;
	DoorAnimation.enter();
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func pickup(item_id, item_type, count: int = 0):
	var id = item_id;
	if id == "triforce_of_power":
		id = "triforce_piece";
	var icon_data = Inventory.get_icon[id][item_type];
	if icon_data.has("pickup_texture"):
		pickup_sprite.texture = icon_data.pickup_texture;
	elif icon_data.has("capacity_texture") and item_type == Inventory.ITEM_TYPES.LVL3:
		pickup_sprite.texture = icon_data.capacity_texture;
	else:
		pickup_sprite.texture = icon_data.texture;
	pickup_sprite.hframes = icon_data.hframes;
	pickup_sprite.vframes = icon_data.vframes;
	pickup_sprite.frame = icon_data.frame;
	if count == 0:
		pickup_sprite.get_node("Amount").text = "";
	else:
		pickup_sprite.get_node("Amount").text = str(count);
		
	if id != "triforce_piece":
		animation_player.play("pickup_item");
		state = STATES.PICKUP;
	else:
		if item_id == "triforce_of_power":
			animation_player.play("pickup_triforce_piece")
			state = STATES.PICKUP;
		else:
			model.reparent(on_top_display_viewport, true);
			animation_player.play("pickup_triforce_piece");
			state = STATES.TRIFORCE_PICKUP;
	velocity = Vector3.ZERO;
	%CameraPivot.orient_behind_link();

func look_in_dir(dir: Vector3):
	if dir.length() < 1: return;
	model.look_at(global_position + dir);
	%CameraPivot.orient_behind_link();

func is_pushing(dir: Vector3) -> bool:
	if move_dir.angle_to(dir) < deg_to_rad(10):
		return true;
	return false;

func push(pushable: StaticBody3D, dir: Vector3):
	state = STATES.PUSH;
	animation_player.play("push");
	push_dir = dir;
	pushing = pushable;
	dist_pushed = 0;

func get_forward():
	return model.transform.basis.z;

func get_grabbed():
	visible = false;
	collision_shape.set_deferred("disabled", true);
	state = STATES.GRABBED;
	velocity = Vector3.ZERO;

func teleport_to_dungeon_beginning():
	global_position = Inventory.get_current_level_beginning();
	collision_shape.set_deferred("disabled", false);
	velocity.y = 6.4;
	visible = true;
	DoorAnimation.exit();
	set_deferred("state", STATES.MOVE);
	
@onready var wizzrobe_spawn_checker: WizzrobeSpawnChecker = get_node("%WizrobeSpawnChecker");
func get_wizzrobe_spawn_position():
	return wizzrobe_spawn_checker.valid_spawn_points.pick_random();

func hold_triforce():
	var icon_data = Inventory.get_icon.triforce_piece[Inventory.ITEM_TYPES.NONE];
	pickup_sprite.texture = icon_data.texture;
	pickup_sprite.hframes = icon_data.hframes;
	pickup_sprite.vframes = icon_data.vframes;
	pickup_sprite.frame = icon_data.frame;
	animation_player.play("pickup_triforce_piece");
	state = STATES.TRIFORCE_PICKUP;
	velocity = Vector3.ZERO;
	%CameraPivot.orient_behind_link();

func engage_ganon():
	pickup_sprite.visible = false;
	state = STATES.MOVE;

func touch_zelda(zelda):
	velocity = Vector3.ZERO;
	animation_player.play("idle_no_sword");
	state = STATES.ENDING_CUTSCENE;
	look_at(zelda.global_position);
	model.reparent(on_top_display_viewport, true);
	zelda.call_deferred("reparent", on_top_display_viewport, true);
	%CameraPivot.play_ending_cutscene();

enum FACE_DIRS {N, E, S, W};
var whirlwind: Whirlwind;
const WHIRLWIND_SCENE: PackedScene = preload("res://scenes/link/whirlwind.tscn");

func flute_teleport():
	if Inventory.current_level != Inventory.LEVELS.OVERWORLD: return;
	var forward = get_forward();
	var face_dir: FACE_DIRS = FACE_DIRS.N;
	if forward.angle_to(Vector3.RIGHT) <= deg_to_rad(45):
		face_dir = FACE_DIRS.E;
	elif forward.angle_to(Vector3.LEFT) <= deg_to_rad(45):
		face_dir = FACE_DIRS.W;
	elif forward.angle_to(Vector3.BACK) <= deg_to_rad(45):
		face_dir = FACE_DIRS.S;
	if face_dir == FACE_DIRS.N or face_dir == FACE_DIRS.E:
		Inventory.set_teleport(1);
	else:
		Inventory.set_teleport(-1);
	if not whirlwind:
		whirlwind = WHIRLWIND_SCENE.instantiate();
		whirlwind.position = global_position + Vector3(-12.8, 0, 0);
		get_tree().root.add_child(whirlwind);

func teleport_to(pos):
	global_position = pos;
	collision_shape.set_deferred("disabled", false);
	velocity.y = 6.4;
	visible = true;
	DoorAnimation.exit();
	set_deferred("state", STATES.MOVE);

func disable_hurtbox():
	$HurtBox/CollisionShape3D.set_deferred("disabled", true);

func enable_hurtbox():
	$HurtBox/CollisionShape3D.set_deferred("disabled", false);

func can_helm_splitter():
	if not Inventory.sword_scrolls[Inventory.SWORD_SCROLLS.JUMP_OVER_ATTACK]: return false;
	if not %CameraPivot.target: return false;
	return %CameraPivot.target.global_position.distance_to(global_position) < 2;
