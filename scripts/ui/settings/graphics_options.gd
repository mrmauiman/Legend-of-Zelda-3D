extends OptionButton

func _item_selected(index: int):
	Settings.graphics_mode = Settings.GRAPHICS.HIGH if index == 0 else Settings.GRAPHICS.LOW;

func _ready():
	selected = 0 if Settings.graphics_mode == Settings.GRAPHICS.HIGH else 1;
	item_selected.connect(_item_selected);
