extends MarginContainer

@export var open_button: Button;
@export var close_button: Button;

func _open():
	visible = true;
	close_button.grab_focus();
	if get_parent().has_node("MarginContainer"):
		get_parent().get_node("MarginContainer").locked = true;

func _close():
	visible = false;
	open_button.grab_focus();
	Settings.save();
	if get_parent().has_node("MarginContainer"):
		get_parent().get_node("MarginContainer").locked = false;

func _ready():
	visible = false;
	open_button.pressed.connect(_open);
	close_button.pressed.connect(_close);
