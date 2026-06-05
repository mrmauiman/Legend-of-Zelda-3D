extends OptionButton

func _item_selected(index: int):
	if index == 0:
		Settings.auto_detect_controller_type = true;
	else:
		Settings.auto_detect_controller_type = false;
		Settings.controller_type = (index-1) as Settings.CONTROLLER_TYPES;

func _ready():
	if Settings.auto_detect_controller_type:
		selected = 0;
	else:
		selected = Settings.controller_type + 1;
	item_selected.connect(_item_selected);
