extends Area3D

@export var direction: Vector3 = Vector3.BACK;

func _on_body_entered(body):
	if Inventory.items.raft != Inventory.ITEM_TYPES.NONE and body.is_in_group("Link"):
		body.start_raft(direction, global_position.x);
