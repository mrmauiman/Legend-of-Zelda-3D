extends StaticBody3D

const GHINI_SCENE: PackedScene = preload("res://scenes/enemies/overworld/ghini.tscn");

var spawned = false;

func spawn_ghini():
	spawned = true;
	var current_screen = get_tree().current_scene.get_node("%Screens").get_child(0);
	var ghini = GHINI_SCENE.instantiate();
	ghini.position = (global_position + Vector3(0, 1.6, 0)) - current_screen.global_position;
	ghini.grave = self;
	current_screen.add_child(ghini);

func _on_link_detector_body_entered(body):
	if body.is_in_group("Link") and not spawned:
		spawn_ghini();
