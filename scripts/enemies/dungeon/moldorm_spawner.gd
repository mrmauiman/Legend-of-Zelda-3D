extends CharacterBody3D

const MOLDORM_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/moldorm.tscn");

@export var spawn_segment_wait_time: float = 0.25;
@export var segments: int = 5;

@onready var loadable = get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = loadable.get_node("SpawnChecker");

const LINK_PROXIMITY_NULLIFICATION = 6.4;

func get_random_spawn_pos():
	if len(spawn_checker.valid_spawns) == 0:
		await spawn_checker.spawns_calculated;
	return spawn_checker.valid_spawns.pop_at(randi_range(0, len(spawn_checker.valid_spawns)-1));

func set_spawn_pos():
	if not spawn_checker: 
		visible = true;
		return;
	var pos = await get_random_spawn_pos();
	while((loadable is LoadableManager and pos.distance_to(loadable.link_pos) <= LINK_PROXIMITY_NULLIFICATION)):
		pos = await get_random_spawn_pos();
	visible = true;
	global_position = pos;

var timer: float = 0.1;
var current_segment = 0;

var segment;
var segment_nodes = [];

func _ready():
	call_deferred("set_spawn_pos");

func _process(delta):
	if current_segment >= segments:
		for node in segment_nodes:
			if node: return;
		queue_free();
		return;
	
	timer -= delta;
	if timer <= 0:
		timer = spawn_segment_wait_time;
		current_segment += 1;
		var parent = segment;
		segment = MOLDORM_SCENE.instantiate();
		segment.position = position;
		if parent:
			segment.head = parent;
		segment_nodes.push_back(segment);
		get_parent().add_child(segment);
