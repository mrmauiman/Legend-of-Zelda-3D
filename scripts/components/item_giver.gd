extends Node

@export var enemies: Node3D;
@export var location_id: String;
var item_holder: Enemy;

func _ready():
	if not item_holder: return;
	item_holder.tree_exited.connect(destroy);
	item_holder.update_held_item();

func _process(_delta):
	if not item_holder and enemies.get_child_count() > 0:
		item_holder = enemies.get_child(0);
		var i = 1;
		while not item_holder is Enemy and i < enemies.get_child_count():
			# Make sure the enemy is a valid item holder
			item_holder = enemies.get_child(i);
		item_holder.held_item = location_id;
		item_holder.tree_exited.connect(destroy);
		item_holder.update_held_item();

func destroy():
	queue_free();
