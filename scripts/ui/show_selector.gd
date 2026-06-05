extends Button

@export var info: String = "";

@onready var info_label = get_parent().get_parent().get_parent().get_node("Label");

func _unlocked() -> bool:
	return Inventory.sword_scrolls[$Rolled.frame];

func _ready():
	_focus_exited();
	focus_entered.connect(_focus_entered);
	focus_exited.connect(_focus_exited);

func _process(_delta):
	if not _unlocked():
		$Rolled.visible = false;
	elif $Open.visible == false:
		$Rolled.visible = true;

func _focus_entered():
	if _unlocked():
		custom_minimum_size.x = 80;
		info_label.text = info;
		$Rolled.visible = false;
		$Open.visible = true;

func _focus_exited():
	info_label.text = "";
	custom_minimum_size.x = 40;
	$Rolled.visible = _unlocked();
	$Open.visible = false;
