extends Node2D

@onready var wave = get_node("Template");
@export var pause_time = 0.2;

var timer = 0;

func _process(delta):
	timer -= delta;
	if timer <= 0:
		timer = pause_time;
		var new_wave = wave.duplicate();
		new_wave.on = true;
		new_wave.visible = true;
		new_wave.position = Vector2.ZERO;
		add_child(new_wave);
