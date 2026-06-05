extends OptionButton

func _item_selected(index: int):
	Settings.target_mode = index as Settings.TARGET_MODES;

func _ready():
	selected = Settings.target_mode;
	item_selected.connect(_item_selected);
