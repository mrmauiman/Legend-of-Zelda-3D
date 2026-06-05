extends Node3D

@export var sword_scroll: Inventory.SWORD_SCROLLS;

func _ready():
	$OldManNPC.sword_scroll = sword_scroll;
