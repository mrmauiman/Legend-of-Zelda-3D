extends HSlider

@export var display_label: Label;

const SFX_FOLDER: String = "res://audio/sfx";

func get_random_sfx() -> String:
	var files = DirAccess.get_files_at(SFX_FOLDER);
	var valid_files = [];
	for file in files:
		if not file.ends_with(".import"):
			valid_files.append(str(file));
	var random_file_name = valid_files.pick_random();
	return SFX_FOLDER + "/" + random_file_name;

func _value_changed(new_value):
	Settings.sfx_volume = float(new_value)/100.0;
	display_label.text = str(int(new_value))+"%";

func _drag_ended(_new_value):
	SoundSystem.play_global(get_random_sfx());

func _ready():
	var starting_val = Settings.sfx_volume*100;
	value = starting_val;
	display_label.text = str(int(value))+"%";
	value_changed.connect(_value_changed);
	drag_ended.connect(_drag_ended);
