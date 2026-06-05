extends Node3D

@onready var id = str(name).to_lower();

const CAVE_POSITION = Vector3(0, -12.8, 0);

func spawn_cave():
	if not Randomizer.caves_map.has(id): return;
	var data = Randomizer.caves_map[id].split("/");
	var cave_name: String = data[0];
	var cave_scene = load("res://scenes/environment/caves/"+cave_name+".tscn");
	var cave = cave_scene.instantiate();
	if len(data) == 2:
		cave.location_id = "cave/"+cave_name+"/"+data[1];
	
	cave.position = CAVE_POSITION;
	add_child(cave);

func _ready():
	spawn_cave();
