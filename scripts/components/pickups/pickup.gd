@abstract
class_name Pickup extends CharacterBody3D

@export var boomerang_can_pickup: bool = false;
@export var hidden_by: Node3D;
@export var never_despawn: bool = false;

@onready var area3D: Area3D = $Area3D;

const GRAVITY: float = 64;
const TERMINAL_VEL: float = 128;

const LIFETIME: float = 30;

signal picked_up;

var boomerang;
var life_timer: float = LIFETIME;
var hidden_by_obj = false;
var heart_requirement: int = 0;

@export var hidden_by_enemies: Node3D;

func is_hidden() -> bool:
	return (hidden_by and hidden_by.visible) or (hidden_by_enemies and hidden_by_enemies.get_child_count() > 0);

func can_pickup(_link):
	var enough_hearts = Inventory.counters.heart_containers >= heart_requirement;
	return not is_hidden() and enough_hearts;

@abstract
func pickup(link);

func _ready():
	area3D.body_entered.connect(_on_body_entered);
	area3D.area_entered.connect(_on_area_entered);
	hidden_by_obj = !!hidden_by;

func _process(delta):
	var not_hidden = not is_hidden();
	if not visible and not_hidden:
		SoundSystem.play("res://audio/sfx/item_appeared.wav", global_position);
	visible = not_hidden;
	
	if visible and not never_despawn:
		life_timer -= delta;
		if life_timer <= 0:
			queue_free();
	
	if boomerang:
		global_position = boomerang.global_position;

func _physics_process(delta):
	velocity.y -= (delta * GRAVITY);
	velocity.y = maxf(velocity.y, -TERMINAL_VEL);
	move_and_slide();

func _on_body_entered(body):
	if body.is_in_group("Link") and can_pickup(body):
		pickup(body);
		picked_up.emit();
		queue_free();

func _on_area_entered(area):
	if area.is_in_group("Boomerang") and boomerang_can_pickup:
		boomerang = area;


# match type:
# 	PICKUP_TYPE.ITEM:
# 		
# 	PICKUP_TYPE.COUNTER:
# 		Inventory.counters[pickup_id] += count;
# 		
# 	PICKUP_TYPE.HEART:
# 		Inventory.heal(1);
# 		SoundSystem.play("res://audio/sfx/RupeePickup.wav", global_position);
# 	PICKUP_TYPE.FAIRY:
# 		Inventory.heal(3);
# 		SoundSystem.play("res://audio/sfx/RupeePickup.wav", global_position);
# 	PICKUP_TYPE.CLOCK:
# 		pass
