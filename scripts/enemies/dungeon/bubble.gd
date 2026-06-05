class_name Bubble extends Enemy

# Components
@onready var state_machine: StateMachine = %StateMachine;
@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;

const GRAVITY = 64;

func update_held_item():
	pass;

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();

func parried():
	state_machine.change_state("Stunned", 1.5);
