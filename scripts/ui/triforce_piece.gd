extends TextureRect

@export var piece: Inventory.LEVELS = Inventory.LEVELS.ONE;

func _process(_delta):
	visible = Inventory.levels[piece].triforce_piece;
