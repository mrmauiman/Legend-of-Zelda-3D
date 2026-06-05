extends OptionButton

func _item_selected(index: int):
	Settings.low_health_sound = index == 0;

func _ready():
	selected = 0 if Settings.low_health_sound else 1;
	item_selected.connect(_item_selected);
