extends HSlider

@export var display_label: Label;

func _value_changed(new_value):
	Settings.camera_zoom = float(new_value);
	display_label.text = str(int(new_value));

func _ready():
	var starting_val = Settings.camera_zoom;
	value = starting_val;
	display_label.text = str(int(value));
	value_changed.connect(_value_changed);
