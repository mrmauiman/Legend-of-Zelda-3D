extends MarginContainer

enum TYPE {TRIFORCE, PICKUP}

@export var screen: Vector2i = Vector2.ZERO;
@export var marker_type: TYPE = TYPE.TRIFORCE;

@export var item_location_id: String = "";

@onready var minimap = get_parent().get_parent().get_parent();

func _process(_delta):
	if not minimap is MiniMap:
		minimap = get_parent().get_parent();
	
	if marker_type == TYPE.PICKUP:
		if item_location_id in Inventory.pickup_locations_grabbed:
			get_child(0).frame = 1;
		else:
			get_child(0).frame = 0;
	
	visible = Inventory.levels[minimap.level].compass;
	position = minimap.get_screen_pos(screen);
