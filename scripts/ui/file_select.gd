extends Node2D

func _ready():
	SoundSystem.stop_music();
	show_panel();

func show_panel():
	for i in range(1, 6, 1):
		if i == 1:
			get_node("Slot"+str(i)).grab_focus();
		get_node("Slot"+str(i)).get_display_data();
	
	visible = true;

func hide_panel():
	visible = false;

func _process(_delta):
	position.x = (get_viewport_rect().size.x/2.0) - (1920.0/2.0);
