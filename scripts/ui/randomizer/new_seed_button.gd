extends Button

@onready var seed_input: LineEdit = get_parent().get_parent().get_parent().get_node("%RandomizerSeed");

func _ready():
	pressed.connect(_pressed);
	_pressed();

func _pressed():
	Randomizer.generate_random_seed();
	seed_input.text = Randomizer.randomizer_seed;
