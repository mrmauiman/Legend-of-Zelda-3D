class_name PolsVoice extends Enemy

@onready var state_machine: StateMachine = %StateMachine;
@onready var model: Node3D = get_node("%Model");
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("ColorAnimationPlayer");
@onready var health: Health = %Health;

const GRAVITY = 16;

func update_held_item():
	pass;

func play_hurt_animation():
	animation_player.play("hurt");
	color_animation_player.play("hurt");

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();

func parried(_by):
	state_machine.change_state("Stunned", 1.5);
