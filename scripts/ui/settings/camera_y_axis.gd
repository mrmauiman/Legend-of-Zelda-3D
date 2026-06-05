extends OptionButton

func _item_selected(index: int):
	Settings.camera_y_inverted = index == 1;

func _ready():
	selected = 1 if Settings.camera_y_inverted else 0;
	item_selected.connect(_item_selected);
