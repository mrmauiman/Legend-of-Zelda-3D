extends CanvasLayer

const TIME: float = 1.0;
const OPENING_WAIT: float = 0.5;

@onready var shader: ShaderMaterial = $ColorRect.material;

var timer = 0;

func play():
	DoorAnimation.set_circle_radius(0.6);
	timer = TIME;

func _process(delta):
	if timer > 0:
		timer -= delta;
		var percent = 1.0-(timer/TIME);
		shader.set_shader_parameter("open", percent);

func _ready():
	get_tree().create_timer(OPENING_WAIT, true, false, false).timeout.connect(play);
	shader.set_shader_parameter("open", 0);
