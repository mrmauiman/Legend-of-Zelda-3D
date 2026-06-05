extends CharacterBody3D

var direction: Vector3;
var fire: bool = false;

@export var speed: float = 25;
@export var half_power: bool = false;
@export var life: float = 0.8;

var timer: float = life;

const FIRE_SCENE: PackedScene = preload("res://scenes/link/fire.tscn");

func _ready():
	if not direction:
		queue_free();
	
	if fire:
		%HitBox.add_to_group("Fire");
	
	if half_power:
		%HitBox.damage = %HitBox.damage/2.0;

func _physics_process(delta):
	timer -= delta;
	if timer <= 0:
		queue_free();
		return;
	
	velocity = direction * speed;
	look_at(global_position + velocity);
	
	if %RayCast3D.is_colliding():
		position = %RayCast3D.get_collision_point() + (Vector3.UP * 0.8);
	
	var collision = move_and_collide(velocity * delta);
	if collision:
		if fire:
			var fire_inst = FIRE_SCENE.instantiate();
			fire_inst.position = position;
			fire_inst.direction = direction;
			fire_inst.stationary = true;
			get_tree().root.add_child(fire_inst);
		queue_free();

func blocked(_by):
	queue_free();

func parried(_by):
	direction = -direction;
	var hit_box = %HitBox;
	hit_box.set_collision_layer_value(1, not hit_box.get_collision_layer_value(1));
	hit_box.set_collision_layer_value(2, not hit_box.get_collision_layer_value(2));
	hit_box.set_collision_mask_value(1, not hit_box.get_collision_mask_value(1));
	hit_box.set_collision_mask_value(2, not hit_box.get_collision_mask_value(2));

func hit(_other):
	if fire:
		var fire_inst = FIRE_SCENE.instantiate();
		fire_inst.position = position;
		fire_inst.direction = direction;
		fire_inst.stationary = true;
		get_tree().root.add_child(fire_inst);
	queue_free();
