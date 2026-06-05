extends Enemy

const GRAVITY: float = 64;

@onready var model: Node3D = get_node("Model");
@onready var animation_player: AnimationPlayer = get_node("Model/AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = get_node("Model/ColorAnimationPlayer");
@onready var health: Health = get_node("%Health");
@onready var state_machine: StateMachine = get_node("StateMachine");

# Sights
@onready var stomp_sight: Area3D = get_node("%StompSight");
@onready var charge_sight: ShapeCast3D = get_node("%ChargeSight");

# Stomp Cooldown
@export var stomp_cooldown: float = 1.4;
var stomp_cooldown_timer: float = 0;

func update_held_item():
	pass;

func check_sights():
	# Check Stomp Sight
	for body in stomp_sight.get_overlapping_bodies():
		if body.is_in_group("Link") and stomp_cooldown_timer <= 0:
			state_machine.change_state("Stomp");
			stomp_cooldown_timer = stomp_cooldown;
			return;
	# Check Charge Sight
	if charge_sight.is_colliding() and charge_sight.get_collider(0) and charge_sight.get_collider(0).is_in_group("Link"):
		state_machine.change_state("Chase");
		return;

func _process(delta):
	super(delta);
	if stomp_cooldown_timer > 0 and not state_machine.current_state_is("Stomp"):
		stomp_cooldown_timer -= delta;

var roar_timer: float = randf_range(2.5, 4);

func _physics_process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = randf_range(2.5, 4);
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();


func _on_hurt_box_area_entered(hitbox):
	if not hitbox is HitBox: return;
	if hitbox.is_bomb:
		state_machine.change_state("Stunned");
	else:
		color_animation_player.play("hurt");
		var damage = hitbox.get_damage()
		if state_machine.current_state_is("Stunned"):
			damage = health.max_health;
		health.take_damage(damage);
		if health.is_dead():
			die();
			return;
