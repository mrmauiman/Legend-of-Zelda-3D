class_name ItemPickup extends Pickup

@export var location_id: String = "";

@onready var sprite: Sprite3D = $Sprite;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;

var type: String;
var item_id: String;
var modifier: int;

func _ready():
	if location_id in Inventory.pickup_locations_grabbed:
		queue_free();
		return ;

	var data = Randomizer.item_map[location_id].split("/");
	type = data[0];
	if type in ["sword_scroll", "compass", "map"]:
		item_id = type;
		modifier = int(data[1]);
	else:
		item_id = data[1];
		modifier = int(data[2]);

	var item_type = 0;
	if type == "item" or type == "sword_scroll":
		item_type = modifier;
	var icon = Inventory.get_icon[item_id][item_type];
	sprite.texture = icon.texture;
	if type == "counter_max":
		sprite.texture = icon.capacity_texture;
	sprite.hframes = icon.hframes;
	sprite.vframes = icon.vframes;
	sprite.frame = icon.frame;
	if icon.flicker:
		animation_player.play(icon.flicker);

	super ();

func pickup(link):
	Inventory.pickup_locations_grabbed.push_back(location_id);
	match type:
		"item":
			if Inventory.items[item_id] < modifier:
				Inventory.items[item_id] = modifier;
			elif item_id == "potion" and Inventory.items[item_id] == modifier:
				Inventory.items[item_id] = Inventory.ITEM_TYPES.LVL2;
			link.pickup(item_id, modifier);
			SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
		"counter":
			Inventory.counters[item_id] = min(Inventory.counters[item_id] + modifier, Inventory.counter_maxes[item_id]);
			if item_id == "rupees" and modifier != 1 and modifier != 5:
				link.pickup(item_id, Inventory.ITEM_TYPES.NONE, modifier);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			elif item_id == "heart_containers":
				Inventory.take_damage(-2);
				link.pickup(item_id, Inventory.ITEM_TYPES.NONE);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			elif item_id == "keys":
				link.pickup(item_id, Inventory.ITEM_TYPES.NONE);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			else:
				SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
		"heart":
			Inventory.take_damage(-2);
			SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
		"counter_max":
			Inventory.counter_maxes[item_id] += modifier;
			Inventory.counters[item_id] = Inventory.counter_maxes[item_id];
			link.pickup(item_id, Inventory.ITEM_TYPES.LVL3);
			SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
		"sword_scroll":
			Inventory.sword_scrolls[modifier] = true;
			link.pickup(item_id, modifier);
			SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
		"map":
			Inventory.levels[modifier as Inventory.LEVELS].map = true;
			link.pickup("map", Inventory.ITEM_TYPES.NONE);
			SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
		"compass":
			Inventory.levels[modifier as Inventory.LEVELS].compass = true;
			link.pickup("compass", Inventory.ITEM_TYPES.NONE);
			SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
