class_name HitBox extends Area3D

@export var knockback: Vector3;
@export var relative_knockback_orientor: Node3D;
@export var xz_omni_dir_knockback: bool = false;
@export var damage: int = 1;
@export var curse_time: float = 0;
@export var is_magic: bool = false;
@export var is_sword: bool = false;
@export var stun_time: float = 0;
@export var is_bomb: bool = false;
@export var is_arrow: bool = false;
@export var weak_enemies_only: bool = false;
@export var no_stun: bool = false;
@export var darknut_cant_block: bool = false;
@export var is_sword_beam: bool = false; # This is a hack used to fix darknut blocking

@warning_ignore("unused_signal")
signal blocked(by);
@warning_ignore("unused_signal")
signal parried(by);
@warning_ignore("unused_signal")
signal hit(body);

func get_damage(weak_enemy: bool = false):
	if is_sword:
		match Inventory.items.sword:
			Inventory.ITEM_TYPES.NONE:
				return 0;
			Inventory.ITEM_TYPES.LVL1:
				return damage;
			Inventory.ITEM_TYPES.LVL2:
				return damage * 2;
			Inventory.ITEM_TYPES.LVL3:
				return damage * 4;
	if weak_enemies_only and not weak_enemy:
		return 0;
	return damage;
