extends MarginContainer

@export var screen: Vector2i = Vector2.ZERO;

@onready var minimap = get_parent().get_parent();

func _process(_delta):
	visible = Inventory.levels[minimap.level].compass;
	
	position = minimap.get_screen_pos(screen);
