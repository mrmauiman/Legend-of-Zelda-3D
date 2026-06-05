extends Enemy

const GRAVITY: float = 64;

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("%AnimationPlayer");
@onready var eye_animation_player: AnimationPlayer = model.get_node("%EyeAnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("%ColorAnimationPlayer");
@onready var health: Health = %Health;

@export var eye_toggle_chance: float = 25;
@export var eye_toggle_time: float = 0.8;

var timer: float = eye_toggle_time;

var eye_open: bool = true;

func update_held_item():
	pass;

func _ready():
	eye_animation_player.animation_finished.connect(_animation_finished);

func _animation_finished(anim):
	if anim == "opening":
		eye_open = true;

func toggle_eye():
	if not eye_open:
		eye_animation_player.play("opening");
	else:
		eye_open = false;
		eye_animation_player.play("closing");

var roar_timer: float = 2.5;
func _physics_process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = 2.5;
	timer -= delta;
	if timer <= 0:
		timer += eye_toggle_time;
		if randf_range(0, 100) < eye_toggle_chance:
			toggle_eye();
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();


func _on_hurt_box_area_entered(area):
	if area is HitBox:
		var hitbox: HitBox = area;
		if hitbox.is_arrow and eye_open:
			color_animation_player.play("hurt");
			health.take_damage(hitbox.get_damage(false));
			hitbox.hit.emit(self);
			if health.is_dead():
				die();
			else:
				SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
		else:
			hitbox.blocked.emit(self);
			SoundSystem.play("res://audio/sfx/Blocked.wav", global_position);
