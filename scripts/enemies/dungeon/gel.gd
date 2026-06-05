class_name Gel extends Enemy

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var health: Health = %Health;
@onready var state_machine: StateMachine = $StateMachine;

var was_zol: bool = false;

const GRAVITY: float = 64;

func update_held_item():
	pass;

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
