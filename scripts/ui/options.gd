extends Button

func _ready():
	pressed.connect(options);

func options():
	PauseMenu.get_node("OptionsMenu")._open(self);
