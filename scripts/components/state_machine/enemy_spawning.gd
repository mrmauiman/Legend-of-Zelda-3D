class_name EnemySpawningState extends State

@onready var loadable = character.get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = loadable.get_node("SpawnChecker");

const LINK_PROXIMITY_NULLIFICATION = 6.4;

func get_random_spawn_pos():
	if len(spawn_checker.valid_spawns) == 0:
		await spawn_checker.spawns_calculated;
	return spawn_checker.valid_spawns.pop_at(randi_range(0, len(spawn_checker.valid_spawns)-1));

func set_spawn_pos():
	if not spawn_checker or (character is Gel and character.was_zol): 
		character.visible = true;
		return;
	var pos = await get_random_spawn_pos();
	while((loadable is LoadableManager and pos.distance_to(loadable.link_pos) <= LINK_PROXIMITY_NULLIFICATION)):
		pos = await get_random_spawn_pos();
	character.visible = true;
	character.global_position = pos;

func spawned():
	state_machine.change_state("Patrol");

func enter(_previous_state: State, _params: Array):
	character.visible = false;
	set_spawn_pos();
func exit(_new_state: State):
	pass;

func update(_delta):
	pass;

func physics_update(_delta):
	pass;
