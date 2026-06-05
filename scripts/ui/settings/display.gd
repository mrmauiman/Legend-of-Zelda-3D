extends OptionButton

func _item_selected(index: int):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);

func _ready():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		selected = 0;
	else:
		selected = 1;
	item_selected.connect(_item_selected);
