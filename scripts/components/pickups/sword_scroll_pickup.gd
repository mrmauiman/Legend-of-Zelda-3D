class_name SwordScroll extends Pickup

@export var sword_scroll: Inventory.SWORD_SCROLLS = Inventory.SWORD_SCROLLS.GREAT_SPIN_ATTACK;

func can_pickup(_link):
	return Inventory.get_max_health() >= Inventory.hearts_to_health(heart_requirement);

func _ready():
	$Sprite.frame = sword_scroll;

func pickup(link):
	Inventory.sword_scrolls[sword_scroll] = true;
	link.pickup("sword_scroll", sword_scroll);
	SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
