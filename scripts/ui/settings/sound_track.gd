extends OptionButton

func _item_selected(index: int):
	Settings.sound_track = index as Settings.SOUND_TRACK;
	SoundSystem.sound_track_changed();

func _ready():
	selected = Settings.sound_track;
	item_selected.connect(_item_selected);
