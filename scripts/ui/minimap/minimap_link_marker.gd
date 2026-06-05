extends MarginContainer

@onready var minimap = get_parent().get_parent();

func _process(_delta):
	visible = !!Inventory.link;
	if not Inventory.link:
		return;
	if Inventory.link.global_position.y < -5:
		return;
	
	var minimap_vec2 = minimap.get_link_minimap_pos();
	position = minimap_vec2 - Vector2(16, 11);
