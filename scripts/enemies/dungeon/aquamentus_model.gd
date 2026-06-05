extends Node3D

@onready var aquamentus: Enemy = get_parent();
@onready var target_arrow_position = %TargetArrowPosition;

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/overworld/zora_fireball.tscn");

var inner = false;

func shoot_fire_balls():
	var angles = [0, -20, 20];
	if inner:
		angles = [-30, -10, 10, 30];
	for angle in angles:
		var dir = Vector3(-1, 0, 0).rotated(Vector3.UP, deg_to_rad(angle));
		var fireball = FIREBALL_SCENE.instantiate();
		fireball.position = global_position + Vector3(0, 0.8, 0) + (dir * 3.2);
		fireball.direction = dir;
		get_tree().root.add_child(fireball);
	inner = not inner;

func _on_hurt_box_area_entered(area: Area3D):
	if area is HitBox:
		aquamentus._on_hurt_box_hit(area);

func _process(_delta):
	aquamentus.target_arrow_offset = target_arrow_position.global_position - aquamentus.global_position;
