class_name Rope extends Enemy

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var health: Health = %Health;
@onready var state_machine: StateMachine = $StateMachine;
@onready var sights: RayCast3D = %Sights;

const GRAVITY: float = 64;

func update_held_item():
	pass;

func check_sights():
	if sights.is_colliding() and sights.get_collider() and sights.get_collider().is_in_group("Link"):
		state_machine.change_state("Chase");

func play_hurt_animation():
	animation_player.play("hurt");

func _ready():
	animation_player.play("walk");

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();
