extends CanvasLayer

@onready var waterfall = get_node("TitleScreen/Node2D");
@onready var waterfall_generator = waterfall.get_node("Node2D");
@onready var waterfall_particles = waterfall.get_node("Sprite2D");

const RELATIVE_POSITION: float = -154;
const RELATIVE_VP_WIDTH: float = 1920;

func align_water_fall():
	if not waterfall.is_inside_tree(): return;
	waterfall.position.x = waterfall.get_viewport_rect().size.x/2.0;
	
	#var vp_width = particles.get_viewport_rect().size.x;
	#var pos = float(vp_width) * (RELATIVE_POSITION/RELATIVE_VP_WIDTH);
	#particles.position.x = pos;
	#waterfall.position.x = pos;

func _ready():
	SoundSystem.play_intro_music();
	# Stop heart beap sound
	Inventory.heal(16);

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/ui/save_select.tscn");
	align_water_fall();
