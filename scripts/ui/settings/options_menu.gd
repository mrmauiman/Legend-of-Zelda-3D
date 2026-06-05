extends MarginContainer

@export var open_button: Button;
@export var close_button: Button;

var current_open_button: Button;
var toggle_pause: bool = false;

func _open(button):
	if not get_tree().paused:
		toggle_pause = true;
		get_tree().paused = true;
	else:
		toggle_pause = false;
	visible = true;
	close_button.grab_focus();
	current_open_button = button;
	if get_parent().has_node("MarginContainer"):
		get_parent().get_node("MarginContainer").locked = true;

func _close():
	if toggle_pause:
		get_tree().paused = false;
	visible = false;
	current_open_button.grab_focus();
	Settings.save();
	if get_parent().has_node("MarginContainer"):
		get_parent().get_node("MarginContainer").locked = false;

func _ready():
	visible = false;
	open_button.pressed.connect(_open.bind(open_button));
	close_button.pressed.connect(_close);
