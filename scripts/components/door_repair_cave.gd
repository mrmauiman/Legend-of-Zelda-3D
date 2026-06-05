extends Node3D

var location_id: String = "";

func _ready():
	$OldManNPC.location_id = location_id;
	if Inventory.door_repairs_visited.has(location_id):
		$OldManNPC.queue_free();
