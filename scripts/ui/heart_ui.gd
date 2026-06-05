extends MarginContainer

@onready var image = get_node("Sprite2D");

@export var pulse_time: float = 0.4;

var timer: float = 0;
var pulse_dir: int = 1;

func pulse(delta):
	timer += delta * pulse_dir;
	if timer <= 0 or timer >= pulse_time:
		pulse_dir *= -1;
	modulate = Color.WHITE.lerp(Color.BLUE, timer/pulse_time);

func _process(delta):
	var heart_num = int(name);
	if heart_num > Inventory.counters.heart_containers:
		if Inventory.get_half_heart_count() <= 2:
			pulse(delta);
		visible = false;
	else:
		visible = true;
		if Inventory.get_half_heart_count() <= 2:
			pulse(delta);
		else:
			modulate = Color.WHITE;
		
		if Inventory.get_half_heart_count() >= heart_num * 2:
			image.frame = 0;
		elif Inventory.get_half_heart_count() <= (heart_num-1) * 2:
			image.frame = 2;
		else:
			image.frame = 1;
