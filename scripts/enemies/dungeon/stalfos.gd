class_name Stalfos extends Enemy


#Sights
@onready var sight:Area3D = %Sight;
@onready var line_of_sight: RayCast3D = sight.get_node("RayCast3D");

# Components
@onready var state_machine: StateMachine = %StateMachine;
@onready var model: Node3D = %Model;
@onready var animation_player: AnimationPlayer = model.get_node("%AnimationPlayer");
@onready var color_animation_player: AnimationPlayer = model.get_node("%ColorAnimationPlayer");
@onready var health: Health = %Health;

const GRAVITY = 64;

func update_held_item():
	if held_item:
		var data = Randomizer.item_map[held_item].split("/");
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
	animation_player.play("hurt");
	color_animation_player.play("hurt");

func check_sights():
	var bodies = sight.get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("Link"):
			line_of_sight.target_position = to_local(body.global_position + Vector3(0, 0.8, 0));
			if not line_of_sight.is_colliding():
				if state_machine.current_state_is("Patrol"):
					state_machine.change_state("Chase", body);
				return;
	if state_machine.current_state_is("Chase"):
		state_machine.change_state("Patrol");


func _physics_process(delta):
	if Inventory.clock_timer > 0:
		state_machine.change_state("Stunned", Inventory.clock_timer);
	
	if state_machine.current_state_is("Spawning"): return;
	
	velocity.y = clampf(velocity.y - (GRAVITY * delta), -GRAVITY, GRAVITY);
	move_and_slide();

func parried():
	state_machine.change_state("Stunned", 1.5);
