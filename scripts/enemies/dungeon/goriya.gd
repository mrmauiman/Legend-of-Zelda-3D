class_name Goriya extends Enemy

const GRAVITY = 64;

@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("ColorAnimationPlayer");
@onready var state_machine: StateMachine = %StateMachine;
@onready var sight: RayCast3D = %Sight;
@onready var health: Health = %Health;

@export var throw_wait: float = 0.5; # Wait time to check if the goriya can throw the boomerang
@export var throw_chance: float = 25; # Chance to throw the boomerang out of 100 every throw_wait seconds

var boomerang_thrown: bool = false;
var throw_chance_active: bool = false;
var throw_timer: float = throw_wait;

func update_held_item():
	if held_item:
		var data = Randomizer.item_map[held_item];
		var type = data[0];
		var pickup = data[1];
		if type in ["sword_scroll", "compass", "map"]:
			pickup = type;
		match pickup:
			"bombs":
				model.has_bomb = true;
			"compass":
				model.has_compass = true;
			"keys":
				model.has_key = true;
			_:
				model.has_item = true;

func _ready():
	model.has_bomb = false;
	model.has_compass = false;
	model.has_key = false;
	model.has_item = false;


func play_hurt_animation():
	if animation_player.current_animation != "throw":
		animation_player.play("hurt");
	color_animation_player.play("hurt");

func set_food(food):
	state_machine.change_state("Eat", food)

func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if throw_timer > 0:
		throw_timer -= delta;
	if throw_timer <= 0:
		throw_chance_active = randf_range(0, 100) < throw_chance;
		throw_timer = throw_wait;
	
	if (not boomerang_thrown) and state_machine.current_state_is("Patrol") and sight.is_colliding() and throw_chance_active:
		var obj = sight.get_collider()
		if obj and obj.is_in_group("Link"):
			state_machine.change_state("Throw");

	if state_machine.current_state_is("Spawning"): return;

	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();
