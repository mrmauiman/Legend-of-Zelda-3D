extends Enemy

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("ColorAnimationPlayer");
@onready var state_machine: StateMachine = %StateMachine;
@onready var health: Health = %Health;

const GRAVITY: float = 64;

var pissed: bool = false;
var roar_timer: float = 2.5;

func recorder_reaction():
	pissed = true;

func update_held_item():
	pass;

func _ready():
	Inventory.recorded_played.connect(recorder_reaction);

func _physics_process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = 2.5;
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();

func _on_hurt_box_hit(hitbox: HitBox):
	color_animation_player.play("hurt");
	health.take_damage(hitbox.get_damage());
	if health.is_dead():
		die();
		return;
	if state_machine.current_state_is("Default"):
		if hitbox.stun_time > 0:
			velocity.x = 0;
			velocity.z = 0;
			state_machine.change_state("Stunned", hitbox.stun_time*1.5);
			animation_player.play("stun_start");
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
	else:
		animation_player.play("hurt");
