extends Area3D

@export var cost: int = 10;

signal paid;

func _ready():
	$Text.text = "-" + str(cost);

func _on_body_entered(body):
	if body.is_in_group("Link") and Inventory.counters.rupees >= cost:
		Inventory.counters.rupees -= cost;
		paid.emit();
