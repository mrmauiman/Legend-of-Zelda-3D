extends StaticBody3D

const ARMOS_SCENE: PackedScene = preload("res://scenes/enemies/overworld/armos.tscn");

func activate():
	var armos = ARMOS_SCENE.instantiate();
	armos.statue = self;
	var current_screen = get_tree().current_scene.get_node("%Screens").get_child(0);
	armos.position = (global_position - current_screen.global_position) + Vector3(0, 0, 0);
	current_screen.add_child(armos);
	disapear();

func _on_activation_area_body_entered(body):
	if visible and body.is_in_group("Link"): activate();

func disapear():
	visible = false;
	collision_layer = 0;

func appear():
	visible = true;
	collision_layer = 1;
