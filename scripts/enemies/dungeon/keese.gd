class_name Keese extends Enemy

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var state_machine: StateMachine = %StateMachine;
@onready var health: Health = %Health;

func update_held_item():
	pass;

func play_hurt_animation():
	animation_player.play("hurt");

func _physics_process(_delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	move_and_slide();
