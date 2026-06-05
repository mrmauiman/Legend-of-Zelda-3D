extends HSlider

@export var display_label: Label;

func _value_changed(new_value):
	Settings.camera_sensitivity = float(new_value)/100.0;
	display_label.text = str(int(new_value))+"%";

func _ready():
	var starting_val = Settings.camera_sensitivity*100;
	value = starting_val;
	display_label.text = str(int(value))+"%";
	value_changed.connect(_value_changed);
