extends Label3D

@export var speed: float = 0.05;

var timer: float = 0;

var original_text: String;
var curr_text: String;

var reveal = false;

signal reveal_complete;

func change_text(p_text: String):
	original_text = p_text;
	curr_text = "";
	for i in range(len(original_text)):
		if original_text[i] != "\n":
			curr_text += " ";
		else:
			curr_text += "\n";
	text = curr_text;
	timer = 0;
	reveal = false;

func reveal_next_char() -> bool:
	SoundSystem.play("res://audio/sfx/TextRevealSound.wav", global_position);
	for i in range(len(original_text)):
		if curr_text[i] != original_text[i]:
			curr_text[i] = original_text[i];
			text = curr_text;
			return i == len(original_text)-1;
	return true;

func _ready():
	change_text(text);

func _process(delta):
	if timer >= speed or not reveal: return;
	timer += delta;
	if timer >= speed:
		if not reveal_next_char():
			timer = 0;
		else:
			reveal_complete.emit();
