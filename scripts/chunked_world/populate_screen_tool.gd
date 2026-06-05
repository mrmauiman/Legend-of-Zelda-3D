@tool
extends Node3D

@export var clean: bool = false:
	set(val):
		clean_screens();

@export var pack: bool = false:
	set(val):
		pack_screens();

@onready var screens = %Screens;
@onready var caves = %Caves;

func get_cave_path(screen_coord: Vector2i) -> String:
	var cave_coord = screen_coord + Vector2i(1, 1);
	var cave_name = "Cave"+str(cave_coord.y)+"_"+str(cave_coord.x);
	return "Row" + str(cave_coord.y) + "/" + cave_name;

func get_coord_from_screen_name(screen_name: String) -> Vector2i:
	var data = screen_name.split("_");
	return Vector2i(int(data[2]), int(data[1]));


func get_screen_save_path(screen_name: String):
	const SCREEN_SCENES_FOLDER_PATH = "res://scenes/chunked_worlds/overworld/screens/";
	screen_name = screen_name.to_lower();
	return SCREEN_SCENES_FOLDER_PATH + screen_name + ".tscn";

func clean_screen(screen: Node3D):
	# Move Enemies in screen to folder
	var enemies_folder = Node3D.new();
	enemies_folder.position = Vector3.ZERO;
	enemies_folder.name = "Enemies";
	screen.add_child(enemies_folder);
	enemies_folder.owner = get_tree().edited_scene_root;

	for enemy in screen.get_children():
		if enemy != enemies_folder:
			enemy.reparent(enemies_folder, true);
	
	# Remove old script
	screen.set_script(null);

	# Reparent associated cave
	var cave_path = get_cave_path(get_coord_from_screen_name(screen.name));
	if caves.has_node(cave_path):
		var cave = caves.get_node(cave_path);
		cave.name = "Cave";
		cave.reparent(screen, true);

func set_node_and_children_owner(screen):
	var enemies_folder = screen.get_node("Enemies");
	enemies_folder.owner = screen;
	for enemy in enemies_folder.get_children():
		enemy.owner = screen;
	
	var cave = screen.get_node("Cave");
	cave.owner = screen;
	for door in cave.get_children():
		if door.is_in_group("Door"):
			door.owner = screen;

func pack_screen(screen: Node3D):
	# Pack Screen into a scene
	var scene = PackedScene.new();

	set_node_and_children_owner(screen);

	var error = scene.pack(screen);
	if error != OK:
		printerr("Failed to pack scene: %s" % error);
		return;
	
	var save_path = get_screen_save_path(screen.name);
	var save_error = ResourceSaver.save(scene, save_path);
	if save_error == OK:
		print("Scene saved successfully to: %s" % save_path);
	else:
		printerr("Failed to save scene file: %s" % save_error);
	
	# Delete Screen
	screen.queue_free();



func clean_screens():
	for screen in screens.get_children():
		clean_screen(screen);

func pack_screens():
	# pack_screen(screens.get_node("Screen_0_8"));
	for screen in screens.get_children():
		pack_screen(screen);