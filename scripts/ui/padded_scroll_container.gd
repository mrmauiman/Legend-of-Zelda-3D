extends ScrollContainer

@export var padding: int = 50;

func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed);

func _on_focus_changed(control: Control):
	if control and is_ancestor_of(control):
		_scroll_to_show(control);

func _scroll_to_show(control: Control):
	var top = int(control.global_position.y - global_position.y + scroll_vertical)-padding;
	var bottom = int(top + control.get_rect().size.y)+padding;
	var v_size = int(get_rect().size.y);
	var scroll_pos = scroll_vertical;
	# box below view
	if top < scroll_pos:
		scroll_vertical = top;
	elif bottom > scroll_pos + v_size:
		scroll_vertical = (bottom - v_size) + padding;
