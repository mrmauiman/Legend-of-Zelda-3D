extends Node3D

func _process(_delta):
	var current_ring = Inventory.items.ring;
	$Pose1/Green.visible = (current_ring == Inventory.ITEM_TYPES.NONE);
	$Pose1/Blue.visible = (current_ring == Inventory.ITEM_TYPES.LVL1);
	$Pose1/Red.visible = (current_ring == Inventory.ITEM_TYPES.LVL2);
	$Pose2/Green.visible = (current_ring == Inventory.ITEM_TYPES.NONE);
	$Pose2/Blue.visible = (current_ring == Inventory.ITEM_TYPES.LVL1);
	$Pose2/Red.visible = (current_ring == Inventory.ITEM_TYPES.LVL2);
