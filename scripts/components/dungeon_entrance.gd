extends Area3D

const OVERWORLD_SCENE_PATH = "res://scenes/chunked_worlds/overworld/overworld.tscn";
const DUNGEONS_FOLDER_PATH = "res://scenes/environment/dungeons/";

func get_dungeon_scene() -> PackedScene:
	var dungeon_name = Randomizer.dungeons_map[str(name).to_lower()];
	if not dungeon_name:
		push_error("dungeon_path not set on entrance: " + name);
	return load(DUNGEONS_FOLDER_PATH+dungeon_name+".tscn");

func change_scene():
	var new_scene: PackedScene;
	if Inventory.current_level == Inventory.LEVELS.OVERWORLD:
		new_scene = get_dungeon_scene();
	else:
		new_scene = load(OVERWORLD_SCENE_PATH);
	get_tree().change_scene_to_packed(new_scene);

func _on_body_entered(body: Node3D):
	if body.is_in_group("Link"):
		body.visible = false;
		DoorAnimation.enter();
		SoundSystem.play_global("res://audio/sfx/UsingStairs.wav");
		get_tree().create_timer(1).timeout.connect(change_scene);
