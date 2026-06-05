extends OptionButton

func _item_selected(index: int):
	Settings.camera_x_inverted = index == 1;

func _ready():
	selected = 1 if Settings.camera_x_inverted else 0;
	item_selected.connect(_item_selected);
