extends Enemy

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var color_animation_player: AnimationPlayer = %ColorAnimationPlayer;
@onready var health: Health = %Health;
@onready var state_machine: StateMachine = $StateMachine;

const GRAVITY: float = 64;

func update_held_item():
	pass

func play_hurt_animation():
	color_animation_player.play("hurt");
	animation_player.play("idle");

func _ready():
	animation_player.play("walk");

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	
	velocity.x *= int(animation_player.current_animation_position >= 0.5);
	velocity.z *= int(animation_player.current_animation_position >= 0.5);

	move_and_slide();

const GEL_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/gel.tscn");
const SPAWN_COUNT: int = 2;
func split():
	# Spawn 2 gel
	for i in range(SPAWN_COUNT):
		var gel = GEL_SCENE.instantiate();
		gel.position = position + Vector3.UP;
		gel.was_zol = true;
		get_parent().add_child(gel);
	
	var effect = ENEMY_DEATH_SCENE.instantiate();
	effect.position = global_position;
	get_tree().root.add_child(effect);
	SoundSystem.play("res://audio/sfx/EnemyDeath.wav", global_position);
	
	queue_free();
