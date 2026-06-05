class_name Health extends Node

@export var max_health: int = 10;
var health = max_health;

func _ready():
	health = max_health;

# Negative damage to heal
func take_damage(damage: int):
	health = clampi(health-damage, 0, max_health);

func is_dead() -> bool:
	return health <= 0;
