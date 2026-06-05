@tool
extends Node3D

const SWORD_BEAM_SCENE: PackedScene = preload("res://scenes/link/sword_beam.tscn");

@onready var link = get_parent();

var beam;

@onready var parts = {
	"link_head": [%GreenTunicHead/Link, %BlueTunicHead/Link, %RedTunicHead/Link],
	"link_torso": [%GreenTunicTorso/Link, %BlueTunicTorso/Link, %RedTunicTorso/Link],
	"zelda_head": [%GreenTunicHead/Zelda, %BlueTunicHead/Zelda, %RedTunicHead/Zelda],
	"zelda_torso": [%GreenTunicTorso/Zelda, %BlueTunicTorso/Zelda, %RedTunicTorso/Zelda],
	"bingus_head": [%BingusHead],
	"bingus_torso": [%GreenTunicTorso/Bingus, %BlueTunicTorso/Bingus, %RedTunicTorso/Bingus],
	"link_appendages": [%LinkLegL, %LinkLegR, %LinkLowerArmL, %LinkLowerArmR, %LinkUpperArmL, %LinkUpperArmR],
	"bingus_appendages": [%BingusLegL, %BingusLegR, %BingusLowerArmL, %BingusLowerArmR, %BingusUpperArmL, %BingusUpperArmR],
	"old_man_head": [%OldManHead],
	"merchant_head": [%MerchantHead],
	"darknut_head": [%GreenTunicHead/Darknut, %BlueTunicHead/Darknut, %RedTunicHead/Darknut],
	"darknut_torso": [%GreenTunicTorso/Darknut, %BlueTunicTorso/Darknut, %RedTunicTorso/Darknut],
	"darknut_appendages": [
		%LowerArmGreenTunicL/Darknut, %LowerArmBlueTunicL/Darknut, %LowerArmRedTunicL/Darknut, 
		%LowerArmGreenTunicR/Darknut, %LowerArmBlueTunicR/Darknut, %LowerArmRedTunicR/Darknut,
		%UpperArmGreenTunicL/Darknut, %UpperArmBlueTunicL/Darknut, %UpperArmRedTunicL/Darknut,
		%UpperArmGreenTunicR/Darknut, %UpperArmBlueTunicR/Darknut, %UpperArmRedTunicR/Darknut,
		%LegGreenTunicL/Darknut, %LegBlueTunicL/Darknut, %LegRedTunicL/Darknut,
		%LegGreenTunicR/Darknut, %LegBlueTunicR/Darknut, %LegRedTunicR/Darknut,
	],
	"shadow_head": [%GreenTunicHead/Shadow, %BlueTunicHead/Shadow, %RedTunicHead/Shadow],
	"shadow_torso": [%GreenTunicTorso/Shadow, %BlueTunicTorso/Shadow, %RedTunicTorso/Shadow],
	"shadow_appendages": [%ShadowLegL, %ShadowLegR, %ShadowLowerArmL, %ShadowLowerArmR, %ShadowUpperArmL, %ShadowUpperArmR],
	"tingle_head": [%GreenTunicHead/Tingle, %BlueTunicHead/Tingle, %RedTunicHead/Tingle],
	"tingle_torso": [%GreenTunicTorso/Tingle, %BlueTunicTorso/Tingle, %RedTunicTorso/Tingle],
	"tingle_appendages": [
		%LowerArmGreenTunicL/Tingle, %LowerArmBlueTunicL/Tingle, %LowerArmRedTunicL/Tingle, 
		%LowerArmGreenTunicR/Tingle, %LowerArmBlueTunicR/Tingle, %LowerArmRedTunicR/Tingle,
		%UpperArmGreenTunicL/Tingle, %UpperArmBlueTunicL/Tingle, %UpperArmRedTunicL/Tingle,
		%UpperArmGreenTunicR/Tingle, %UpperArmBlueTunicR/Tingle, %UpperArmRedTunicR/Tingle,
		%LegGreenTunicL/Tingle, %LegBlueTunicL/Tingle, %LegRedTunicL/Tingle,
		%LegGreenTunicR/Tingle, %LegBlueTunicR/Tingle, %LegRedTunicR/Tingle,
	],
	"midna_head": [%GreenTunicHead/Midna, %BlueTunicHead/Midna, %RedTunicHead/Midna],
	"midna_torso": [%MidnaTorso],
	"midna_appendages": [
		%LowerArmGreenTunicL/Midna, %LowerArmBlueTunicL/Midna, %LowerArmRedTunicL/Midna, 
		%LowerArmGreenTunicR/Midna, %LowerArmBlueTunicR/Midna, %LowerArmRedTunicR/Midna,
		%UpperArmGreenTunicL/Midna, %UpperArmBlueTunicL/Midna, %UpperArmRedTunicL/Midna,
		%UpperArmGreenTunicR/Midna, %UpperArmBlueTunicR/Midna, %UpperArmRedTunicR/Midna,
		%LegGreenTunicL/Midna, %LegBlueTunicL/Midna, %LegRedTunicL/Midna,
		%LegGreenTunicR/Midna, %LegBlueTunicR/Midna, %LegRedTunicR/Midna,
	],
	"legend_head": [%GreenTunicHead/Legend, %BlueTunicHead/Legend, %RedTunicHead/Legend],
	"legend_torso": [%GreenTunicTorso/Legend, %BlueTunicTorso/Legend, %RedTunicTorso/Legend],
	"legend_appendages": [
		%LowerArmGreenTunicL/Legend, %LowerArmBlueTunicL/Legend, %LowerArmRedTunicL/Legend, 
		%LowerArmGreenTunicR/Legend, %LowerArmBlueTunicR/Legend, %LowerArmRedTunicR/Legend,
		%UpperArmGreenTunicL/Legend, %UpperArmBlueTunicL/Legend, %UpperArmRedTunicL/Legend,
		%UpperArmGreenTunicR/Legend, %UpperArmBlueTunicR/Legend, %UpperArmRedTunicR/Legend,
		%LegendLegR, %LegendLegL
	],
	"minish_head": [%GreenTunicHead/Minish, %BlueTunicHead/Minish, %RedTunicHead/Minish],
	"minish_torso": [%GreenTunicTorso/Minish, %BlueTunicTorso/Minish, %RedTunicTorso/Minish],
	"minish_appendages": [
		%LowerArmGreenTunicL/Minish, %LowerArmBlueTunicL/Minish, %LowerArmRedTunicL/Minish, 
		%LowerArmGreenTunicR/Minish, %LowerArmBlueTunicR/Minish, %LowerArmRedTunicR/Minish,
		%UpperArmGreenTunicL/Minish, %UpperArmBlueTunicL/Minish, %UpperArmRedTunicL/Minish,
		%UpperArmGreenTunicR/Minish, %UpperArmBlueTunicR/Minish, %UpperArmRedTunicR/Minish,
		%MinishLegR, %MinishLegL
	],
	"moblin_head": [%GreenTunicHead/Moblin, %BlueTunicHead/Moblin, %RedTunicHead/Moblin],
	"moblin_torso": [%GreenTunicTorso/Moblin, %BlueTunicTorso/Moblin, %RedTunicTorso/Moblin],
	"moblin_appendages": [
		%LowerArmGreenTunicL/Moblin, %LowerArmBlueTunicL/Moblin, %LowerArmRedTunicL/Moblin, 
		%LowerArmGreenTunicR/Moblin, %LowerArmBlueTunicR/Moblin, %LowerArmRedTunicR/Moblin,
		%UpperArmGreenTunicL/Moblin, %UpperArmBlueTunicL/Moblin, %UpperArmRedTunicL/Moblin,
		%UpperArmGreenTunicR/Moblin, %UpperArmBlueTunicR/Moblin, %UpperArmRedTunicR/Moblin,
		%LegGreenTunicL/Moblin, %LegBlueTunicL/Moblin, %LegRedTunicL/Moblin,
		%LegGreenTunicR/Moblin, %LegBlueTunicR/Moblin, %LegRedTunicR/Moblin,
	],
	"stalfos_head": [%GreenTunicHead/Stalfos, %BlueTunicHead/Stalfos, %RedTunicHead/Stalfos],
	"stalfos_torso": [%StalfosTorso],
	"stalfos_appendages": [%StalfosUpperArmL, %StalfosUpperArmR, %StalfosLowerArmL, %StalfosLowerArmR, %StalfosLegL, %StalfosLegR],
	"goriya_head": [%GreenTunicHead/Goriya, %BlueTunicHead/Goriya, %RedTunicHead/Goriya],
	"goriya_torso": [%GreenTunicTorso/Goriya, %BlueTunicTorso/Goriya, %RedTunicTorso/Goriya],
	"goriya_appendages": [
		%LowerArmGreenTunicL/Goriya, %LowerArmBlueTunicL/Goriya, %LowerArmRedTunicL/Goriya, 
		%LowerArmGreenTunicR/Goriya, %LowerArmBlueTunicR/Goriya, %LowerArmRedTunicR/Goriya,
		%UpperArmGreenTunicL/Goriya, %UpperArmBlueTunicL/Goriya, %UpperArmRedTunicL/Goriya,
		%UpperArmGreenTunicR/Goriya, %UpperArmBlueTunicR/Goriya, %UpperArmRedTunicR/Goriya,
		%LegGreenTunicL/Goriya, %LegBlueTunicL/Goriya, %LegRedTunicL/Goriya,
		%LegGreenTunicR/Goriya, %LegBlueTunicR/Goriya, %LegRedTunicR/Goriya,
	],
	"armos_head": [%GreenTunicHead/Armos, %BlueTunicHead/Armos, %RedTunicHead/Armos],
	"armos_torso": [%GreenTunicTorso/Armos, %BlueTunicTorso/Armos, %RedTunicTorso/Armos],
	"armos_appendages": [
		%LowerArmGreenTunicL/Armos, %LowerArmBlueTunicL/Armos, %LowerArmRedTunicL/Armos, 
		%LowerArmGreenTunicR/Armos, %LowerArmBlueTunicR/Armos, %LowerArmRedTunicR/Armos,
		%UpperArmGreenTunicL/Armos, %UpperArmBlueTunicL/Armos, %UpperArmRedTunicL/Armos,
		%UpperArmGreenTunicR/Armos, %UpperArmBlueTunicR/Armos, %UpperArmRedTunicR/Armos,
		%LegGreenTunicL/Armos, %LegBlueTunicL/Armos, %LegRedTunicL/Armos,
		%LegGreenTunicR/Armos, %LegBlueTunicR/Armos, %LegRedTunicR/Armos,
	],
};

@onready var tunics = {
	Inventory.ITEM_TYPES.NONE: [%GreenTunicHead, %GreenTunicTorso, %LowerArmGreenTunicL, %LowerArmGreenTunicR, %UpperArmGreenTunicL, %UpperArmGreenTunicR, %LegGreenTunicL, %LegGreenTunicR],
	Inventory.ITEM_TYPES.LVL1: [%BlueTunicHead, %BlueTunicTorso, %LowerArmBlueTunicL, %LowerArmBlueTunicR, %UpperArmBlueTunicL, %UpperArmBlueTunicR, %LegBlueTunicL, %LegBlueTunicR],
	Inventory.ITEM_TYPES.LVL2: [%RedTunicHead, %RedTunicTorso, %LowerArmRedTunicL, %LowerArmRedTunicR, %UpperArmRedTunicL, %UpperArmRedTunicR, %LegRedTunicL, %LegRedTunicR],
}

var characters = {
	"link": ["link_head", "link_torso", "link_appendages"],
	"zelda": ["zelda_head", "zelda_torso", "link_appendages"],
	"bingus": ["bingus_head", "bingus_torso", "bingus_appendages"],
	"old man": ["old_man_head", "link_torso", "link_appendages"],
	"merchant": ["merchant_head", "link_torso", "link_appendages"],
	"darknut": ["darknut_head", "darknut_torso", "darknut_appendages"],
	"shadow": ["shadow_head", "shadow_torso", "shadow_appendages"],
	"tingle": ["tingle_head", "tingle_torso", "tingle_appendages"],
	"midna": ["midna_head", "midna_torso", "midna_appendages"],
	"legend": ["legend_head", "legend_torso", "legend_appendages"],
	"minish": ["minish_head", "minish_torso", "minish_appendages"],
	"moblin": ["moblin_head", "moblin_torso", "moblin_appendages"],
	"stalfos": ["stalfos_head", "stalfos_torso", "stalfos_appendages"],
	"goriya": ["goriya_head", "goriya_torso", "goriya_appendages"],
	"armos": ["armos_head", "armos_torso", "armos_appendages"],
};

@export var display = "link":
	set(val):
		display = val;
		if display in characters and parts:
			for part in parts:
				for sprite in parts[part]:
					sprite.visible = part in characters[display];

func _fire_sword_beam():
	if Inventory.full_health() and not beam:
		beam = SWORD_BEAM_SCENE.instantiate();
		var forward = get_parent().get_forward();
		beam.direction = forward;
		beam.position = global_position + forward;
		get_tree().root.add_child(beam);
		SoundSystem.play("res://audio/sfx/SwordBeam.wav", global_position);

func _ready():
	if Engine.is_editor_hint(): return;
	
	# Set Character
	var link_name = Inventory.link_name.to_lower();
	if not characters.has(link_name):
		link_name = "link";
	for part in parts:
		for sprite in parts[part]:
			if not sprite: print(parts[part]);
			if not part in characters[link_name]:
				sprite.queue_free();
			else:
				sprite.visible = true;

func _process(_delta):
	if Engine.is_editor_hint(): return;
	
	if Inventory.clock_timer > 0:
		$ColorAnimationPlayer.play("invincible");
	elif $ColorAnimationPlayer.current_animation == "invincible":
		$ColorAnimationPlayer.play("normal");
	
	# Swords
	match Inventory.items.sword:
		Inventory.ITEM_TYPES.NONE:
			if %Sword.visible: %Sword.visible = false;
			if %WhiteSword.visible: %WhiteSword.visible = false;
			if %MagicSword.visible: %MagicSword.visible = false;
		Inventory.ITEM_TYPES.LVL1:
			if not %Sword.visible: %Sword.visible = true;
			if %WhiteSword.visible: %WhiteSword.visible = false;
			if %MagicSword.visible: %MagicSword.visible = false;
		Inventory.ITEM_TYPES.LVL2:
			if %Sword.visible: %Sword.visible = false;
			if not %WhiteSword.visible: %WhiteSword.visible = true;
			if %MagicSword.visible: %MagicSword.visible = false;
		Inventory.ITEM_TYPES.LVL3:
			if %Sword.visible: %Sword.visible = false;
			if %WhiteSword.visible: %WhiteSword.visible = false;
			if not %MagicSword.visible: %MagicSword.visible = true;
	# Sword Curse
	%CursedSwordEffect.visible = link.curse_timer > 0;
	
	
	#Shields
	match Inventory.items.shield:
		Inventory.ITEM_TYPES.LVL1:
			if not %Shield.visible: %Shield.visible = true;
			if %MagicShield.visible: %MagicShield.visible = false;
		Inventory.ITEM_TYPES.LVL2:
			if %Shield.visible: %Shield.visible = false;
			if not %MagicShield.visible: %MagicShield.visible = true;
	
	# Rings
	for tunic in tunics:
		for sprite in tunics[tunic]:
			sprite.visible = tunic == Inventory.items.ring;
	
	# Boomerangs
	match Inventory.items.boomerang:
		Inventory.ITEM_TYPES.NONE:
			if %Boomerang.visible: %Boomerang.visible = false;
			if %MagicBoomerang.visible: %MagicBoomerang.visible = false;
		Inventory.ITEM_TYPES.LVL1:
			if not %Boomerang.visible: %Boomerang.visible = true;
			if %MagicBoomerang.visible: %MagicBoomerang.visible = false;
		Inventory.ITEM_TYPES.LVL2:
			if %Boomerang.visible: %Boomerang.visible = false;
			if not %MagicBoomerang.visible: %MagicBoomerang.visible = true;
	
	# Arrows
	if Inventory.items.arrow == Inventory.ITEM_TYPES.NONE or Inventory.counters.rupees == 0:
		%ArrowSprite.visible = false;
	elif Inventory.items.arrow == Inventory.ITEM_TYPES.LVL1:
		%ArrowSprite.visible = true;
		%ArrowSprite.frame = 0;
	elif Inventory.items.arrow == Inventory.ITEM_TYPES.LVL2:
		%ArrowSprite.visible = true;
		%ArrowSprite.frame = 1;
	
	# Candles
	match Inventory.items.candle:
		Inventory.ITEM_TYPES.NONE:
			%Candle.visible = false;
			%MagicCandle.visible = false;
		Inventory.ITEM_TYPES.LVL1:
			%Candle.visible = true;
			%MagicCandle.visible = false;
		Inventory.ITEM_TYPES.LVL2:
			%Candle.visible = false;
			%MagicCandle.visible = true;
	#  Flames
	if Inventory.candle_available:
		%Flame.visible = true;
		%MagicFlame.visible = true;
	else:
		%Flame.visible = false;
		%MagicFlame.visible = false;
	
	# Potions
	match Inventory.items.potion:
		Inventory.ITEM_TYPES.NONE:
			%RedPotion.visible = false;
			%BluePotion.visible = false;
		Inventory.ITEM_TYPES.LVL1:
			%RedPotion.visible = false;
			%BluePotion.visible = true;
		Inventory.ITEM_TYPES.LVL2:
			%RedPotion.visible = true;
			%BluePotion.visible = false;
	
	# Book
	match Inventory.items.book_of_magic:
		Inventory.ITEM_TYPES.NONE:
			%BookModel.visible = false;
		Inventory.ITEM_TYPES.LVL1:
			%BookModel.visible = true;
