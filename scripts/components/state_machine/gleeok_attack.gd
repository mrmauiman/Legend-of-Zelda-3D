extends State

@export var build_up_time: float = 0.6;

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/gleeok_fireball.tscn");

var timer: float = build_up_time;

func fire():
	var link = Inventory.get_link();
	if not link:
		return;
	var goal = link.global_position + (Vector3.UP * 0.8);
	var fireball = FIREBALL_SCENE.instantiate();
	fireball.position = character.global_position;
	fireball.direction = (goal-character.global_position).normalized();
	get_tree().root.add_child(fireball);

func enter(_previous_state: State, _params: Array):
	timer = build_up_time;

func exit(_new_state: State):
	timer = build_up_time;

func update(delta):
	timer -= delta;

func physics_update(_delta):
	if timer <= 0:
		fire();
		state_machine.change_state("Patrol");
