extends Node3D

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer");

var location_id: String = "";

var revealed = false;
var exited = false;

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.reveal = true;

func _take_money():
	Inventory.counters.rupees = max(Inventory.counters.rupees-20, 0);
	if exited:
		queue_free();
	revealed = true;
	Inventory.door_repairs_visited.push_back(location_id);

func _ready():
	if Inventory.door_repairs_visited.has(location_id):
		queue_free();
	
	%Text.reveal_complete.connect(_take_money);


func _on_text_trigger_body_exited(body):
	if body.is_in_group("Link"):
		if revealed:
			queue_free();
		exited = true;
