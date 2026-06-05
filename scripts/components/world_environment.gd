extends WorldEnvironment

func update_graphics():
	environment.sdfgi_enabled = Settings.graphics_mode == Settings.GRAPHICS.HIGH;

func _ready():
	update_graphics();
	Settings.graphics_changed.connect(update_graphics);
