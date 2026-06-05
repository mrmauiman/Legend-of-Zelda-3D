extends Area3D

@onready var sprite: Sprite3D = $Sprite;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;

@export var id: String = "shop_x/item_x"
@export var multi_purchase: bool = true;
@export var price: int = 10;

signal picked_up;

var type: String;
var item_id: String;
var modifier: int;

func _ready():
	var data;
	if multi_purchase:
		data = Randomizer.shop_map[id].split("/");
	else:
		if id in Inventory.pickup_locations_grabbed:
			queue_free();
		data = Randomizer.item_map[id].split("/");
	type = data[0];
	if len(data) > 2:
		item_id = data[1];
		modifier = int(data[2]);
	else:
		item_id = data[0];
		modifier = int(data[1]);
	
	%Text.text = str(price);
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

func _on_body_entered(body):
	if not multi_purchase:
		Inventory.pickup_locations_grabbed.push_back(id);
	if body.is_in_group("Link") and Inventory.counters.rupees >= price:
		match type:
			"item":
				if Inventory.items[item_id] < modifier:
					Inventory.items[item_id] = modifier;
				elif item_id == "potion" and Inventory.items[item_id] == modifier:
					Inventory.items[item_id] = Inventory.ITEM_TYPES.LVL2;
				body.pickup(item_id, modifier);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			"counter":
				Inventory.counters[item_id] += modifier;
				if item_id == "rupees" and modifier != 1 and modifier != 5:
					body.pickup(item_id, Inventory.ITEM_TYPES.NONE, modifier);
					SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
				elif item_id == "heart_containers":
					Inventory.heart_container_levels[Inventory.current_level] = true;
					Inventory.take_damage(-2);
					body.pickup(item_id, Inventory.ITEM_TYPES.NONE);
					SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
				elif item_id == "keys":
					body.pickup(item_id, Inventory.ITEM_TYPES.NONE);
					SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
				else:
					SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
			"heart":
				Inventory.take_damage(-2);
				SoundSystem.play_global("res://audio/sfx/RupeePickup.wav");
			"counter_max":
				Inventory.counter_maxes[item_id] += modifier;
				Inventory.counters[item_id] = Inventory.counter_maxes[item_id];
				body.pickup(item_id, Inventory.ITEM_TYPES.LVL3);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			"sword_scroll":
				Inventory.sword_scrolls[modifier] = true;
				body.pickup(item_id, modifier);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			"map":
				Inventory.levels[modifier as Inventory.LEVELS].map = true;
				body.pickup("map", Inventory.ITEM_TYPES.NONE);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
			"compass":
				Inventory.levels[modifier as Inventory.LEVELS].compass = true;
				body.pickup("compass", Inventory.ITEM_TYPES.NONE);
				SoundSystem.play_global("res://audio/sfx/PickupItem.wav");
				
		Inventory.counters.rupees -= price;
		picked_up.emit();
		queue_free();
