extends CharacterBody3D

var direction: Vector3;
var fire: bool = false;

@export var speed: float = 25.6;
@export var life: float = 0.8;

const ARROW_SCENE: PackedScene = preload("res://scenes/link/arrow.tscn");

var frame = 0;
var timer: float = life;

func _ready():
	if not direction:
		queue_free();
	
	%Texture.frame = frame;
	if Inventory.items.arrow == Inventory.ITEM_TYPES.LVL2:
		%HitBox.damage = 8;

func _physics_process(delta):
	timer -= delta;
	if timer <= 0:
		queue_free();
	
	velocity = direction * speed;
	look_at(global_position + velocity);
	
	if %RayCast3D.is_colliding():
		position = %RayCast3D.get_collision_point() + (Vector3.UP * 0.8);
	
	var collision = move_and_collide(velocity * delta);
	if collision:
		destroy();

func destroy():
	queue_free();

func hit_blocked(_body):
	destroy();

func hit_enemy(enemy_hurtbox):
	if not enemy_hurtbox.get("arrow_weakness"):
		destroy();

func parried(_by):
	direction *= -1;
	%HitBox.damage *= 2;
	%HitBox.set_collision_layer_value(3, true);
	%HitBox.set_collision_layer_value(2, false);
	%HitBox.set_collision_mask_value(3, false);
	%HitBox.set_collision_mask_value(2, true);
