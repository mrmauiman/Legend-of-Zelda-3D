extends Node3D

@onready var screen := get_parent();
@onready var spawn_checker: SpawnChecker = screen.get_node("SpawnChecker");

@export var is_beach = false;
@export var static_enemy_y_level: float = 0.0;
var beach_sound_wait = 3.7;
var beach_sound_chance = 70;
var beach_timer = beach_sound_wait;

const LINK_PROXIMITY_NULLIFICATION = 3.2;

const ENEMY_SCENES = {
	"armos": preload("res://scenes/enemies/overworld/armos.tscn"),
	"ghini": preload("res://scenes/enemies/overworld/ghini.tscn"),
	"leever": preload("res://scenes/enemies/overworld/leever.tscn"),
	"leever_blue": preload("res://scenes/enemies/overworld/leever_blue.tscn"),
	"lynel": preload("res://scenes/enemies/overworld/lynel.tscn"),
	"lynel_blue": preload("res://scenes/enemies/overworld/lynel_blue.tscn"),
	"moblin": preload("res://scenes/enemies/overworld/moblin.tscn"),
	"moblin_blue": preload("res://scenes/enemies/overworld/moblin_blue.tscn"),
	"octorock": preload("res://scenes/enemies/overworld/octorock.tscn"),
	"octorock_blue": preload("res://scenes/enemies/overworld/octorock_blue.tscn"),
	"peahat": preload("res://scenes/enemies/overworld/peahat.tscn"),
	"rock_slide_area": preload("res://scenes/enemies/overworld/rock_slide_area.tscn"),
	"tektite": preload("res://scenes/enemies/overworld/tektite.tscn"),
	"tektite_blue": preload("res://scenes/enemies/overworld/tektite_blue.tscn"),
	"zora": preload("res://scenes/enemies/overworld/zora.tscn"),
};

func screen_name() -> String:
	return str(screen.name).to_lower();

func get_spawn_pos():
	if not spawn_checker:
		await ready;
	if not spawn_checker.spawns_calculated_flag:
		await spawn_checker.spawns_calculated;
	else:
		await get_tree().process_frame;
	#print(spawn_checker.valid_spawns);
	var link = Inventory.get_link();
	var pos = spawn_checker.valid_spawns.pop_at(randi_range(0, len(spawn_checker.valid_spawns)-1));
	while pos.distance_to(link.global_position) < LINK_PROXIMITY_NULLIFICATION:
		pos = spawn_checker.valid_spawns.pop_at(randi_range(0, len(spawn_checker.valid_spawns)-1));
	return pos;

func spawn_enemy(enemy_name: String, enemy_index: int):
	var enemy = ENEMY_SCENES[enemy_name].instantiate();
	if not enemy_name in Randomizer.static_enemy_pool:
		enemy.position = (await get_spawn_pos()) - global_position;
	else:
		enemy.position = Vector3(0, static_enemy_y_level, 0);
	enemy.name = enemy_name+str(enemy_index);
	add_child(enemy);

func _ready():
	var screen_enemies = Randomizer.overworld_enemies_map[screen_name()];
	var data := {};
	if EnemyTracker.has_screen_data(screen_name()) and not EnemyTracker.should_respawn[screen_name()]:
		data = EnemyTracker.get_screen_data(screen_name());
	else:
		var i = 0;
		for enemy in screen_enemies:
			data[enemy+str(i)] = "alive";
			i+=1;
		EnemyTracker.add_screen_data(screen_name(), data);

	var i = 0;
	for enemy in screen_enemies:
		if data[enemy+str(i)] == "alive":
			await spawn_enemy(enemy, i);
		i+=1;
	
	if not spawn_checker:
		printerr("Spawn Checker not set for screen: " + screen_name());

func _process(delta):
	if is_beach:
		beach_timer -= delta;
		if beach_timer <= 0:
			beach_timer += beach_sound_wait;
			if randf_range(0, 100) < beach_sound_chance:
				SoundSystem.play_global("res://audio/sfx/Waves.mp3");

func _exit_tree():
	var data = EnemyTracker.get_screen_data(screen_name());
	for enemy_name in data:
		data[enemy_name] = "alive" if has_node(str(enemy_name)) else "dead";
	EnemyTracker.add_screen_data(screen_name(), data);
