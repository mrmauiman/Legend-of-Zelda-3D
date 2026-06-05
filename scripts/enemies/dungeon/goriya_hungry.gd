class_name GoriyaHungry extends Enemy

const GRAVITY = 64;

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer");
@onready var state_machine: StateMachine = %StateMachine;

func update_held_item():
	pass;

func set_food(food):
	state_machine.change_state("Eat", food)

func _physics_process(delta):
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();
