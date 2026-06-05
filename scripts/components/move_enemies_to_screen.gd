@tool
extends Node3D

const WIDTH: int = 16;
const HEIGHT: int = 8;

const WORLD_WIDTH: float = WIDTH * 25.6;
const WORLD_HEIGHT: float = HEIGHT * 17.6;

@export var move: bool:
	set(val):
		move_enemies();

func get_screen(coord: Vector2) -> String:
	
	var screen_x = floori(((coord.x + (WORLD_WIDTH/2))/WORLD_WIDTH) * WIDTH);
	var screen_y = floori(((WORLD_HEIGHT - (coord.y + (WORLD_HEIGHT/2)))/WORLD_HEIGHT) * HEIGHT);
	
	return "Screen_" + str(screen_y) + "_" + str(screen_x);

func move_enemies():
	var screens = {};
	for enemy_group in get_children():
		for enemy in enemy_group.get_children():
			var screen_name = get_screen(Vector2(enemy.global_position.x, enemy.global_position.z));
			if not screens.has(screen_name):
				screens[screen_name] = [];
			screens[screen_name].push_back(enemy);
	for screen_name in screens:
		for enemy: Node3D in screens[screen_name]:
			enemy.reparent(%Screens.get_node(screen_name));
