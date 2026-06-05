extends Node3D

const GAME_RUPEE_SCENE: PackedScene = preload("res://scenes/npcs/money_making_game_rupee.tscn");

@export_multiline var text: String = "";
@export_multiline var not_enough_text: String = "";

var very_bad_rupee;
var bad_rupee;
var good_rupee;

func clear_game():
	if very_bad_rupee:
		very_bad_rupee.queue_free();
	if bad_rupee:
		bad_rupee.queue_free();
	if good_rupee:
		good_rupee.queue_free();

func spawn_payments():
	var spots = [Vector3(-3.2, 0, 2.4), Vector3(0, 0, 2.4), Vector3(3.2, 0, 2.4)]
	very_bad_rupee = GAME_RUPEE_SCENE.instantiate();
	very_bad_rupee.count = [-40, -10].pick_random();
	var spot = randi_range(1, 3)-1;
	very_bad_rupee.position = spots.pop_at(spot);
	add_child(very_bad_rupee);
	very_bad_rupee.picked_up.connect(clear_game);
	
	bad_rupee = GAME_RUPEE_SCENE.instantiate();
	bad_rupee.count = -10;
	spot = randi_range(1, 2)-1;
	bad_rupee.position = spots.pop_at(spot);
	add_child(bad_rupee);
	bad_rupee.picked_up.connect(clear_game);
	
	good_rupee = GAME_RUPEE_SCENE.instantiate();
	good_rupee.count = [50, 20].pick_random();
	good_rupee.position = spots[0];
	add_child(good_rupee);
	good_rupee.picked_up.connect(clear_game);

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		if Inventory.counters.rupees >= 10:
			%Text.change_text(text);
			%Text.reveal = true;
			%Text.reveal_complete.connect(spawn_payments, CONNECT_ONE_SHOT);
		else:
			%Text.change_text(not_enough_text);
			%Text.reveal = true;

func _on_text_trigger_body_exited(body):
	if body.is_in_group("Link"):
		clear_game();
