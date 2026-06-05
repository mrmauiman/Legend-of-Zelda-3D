@abstract
class_name Enemy extends CharacterBody3D

@export var target_arrow_offset: Vector3;
@export var drop_group: EnemyDrops.ENEMY_GROUPS;
@export var attracted_to_food: bool = false;

const ENEMY_DEATH_SCENE: PackedScene = preload("res://scenes/enemies/death_effect.tscn");
const ENEMY_LOAD_DIST: float = 40;

const ITEM_PICKUP_SCENE: PackedScene = preload("res://scenes/pickups/item_pickup.tscn");

var camera: Camera3D;

var clock_stun = false;
var held_item: String :
	set(val):
		held_item = val;
		update_held_item();

func play_hurt_animation():
	return;

@abstract
func update_held_item();

func _process(_delta):
	if Engine.is_editor_hint():
		return;
	clock_stun = Inventory.clock_timer > 0;

func die():
	var effect = ENEMY_DEATH_SCENE.instantiate();
	effect.position = global_position;
	get_tree().root.add_child(effect);
	SoundSystem.play("res://audio/sfx/EnemyDeath.wav", global_position);
	
	# Spawn Drops
	if held_item:
		var item = ITEM_PICKUP_SCENE.instantiate();
		item.location_id = held_item;
		item.position = global_position;
		get_tree().root.add_child(item);
	else:
		var drop = EnemyDrops.get_drop(drop_group);
		EnemyDrops.spawn_drop(drop, global_position);
	
	queue_free();
