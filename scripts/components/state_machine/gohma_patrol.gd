class_name GohmaPatrol extends State

const FIREBALL_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/gleeok_fireball.tscn");

@export var move_speed: float = 4.8;
@export var switch_chance: float = 20;
@export var switch_time: float = 0.878;
@export var fireball_chance: float = 35;
@export var fireball_time: float = 0.65;

var dir: int = 1;
var switch_timer: float = switch_time;
var fireball_timer: float = fireball_time;

func should_switch() -> bool:
	return randf_range(0, 100) <= switch_chance;

func should_fire() -> bool:
	return randf_range(0, 100) <= fireball_chance;

func fire():
	var link = Inventory.get_link();
	if not link:
		return;
	var fireball = FIREBALL_SCENE.instantiate();
	var goal = link.global_position + (Vector3.UP * 0.8);
	fireball.position = global_position + (Vector3.UP * 0.8);
	fireball.direction = (goal-global_position).normalized();
	get_tree().root.add_child(fireball);

func enter(_previous_state: State, _params: Array):
	pass

func exit(_new_state: State):
	pass;

func update(_delta):
	pass;

func physics_update(delta):
	switch_timer -= delta;
	if switch_timer <= 0:
		switch_timer += switch_time;
		if should_switch(): dir = -dir;
	
	fireball_timer -= delta;
	if fireball_timer <= 0:
		fireball_timer += fireball_time;
		if should_fire(): fire();
	
	character.velocity.x = move_speed * dir;
	character.animation_player.play("walk_sideways");
	character.animation_player.speed_scale = dir;
	
	if character.is_on_wall():
		var wall_norm = character.get_wall_normal();
		if wall_norm.angle_to(Vector3(-dir, 0, 0)) < deg_to_rad(90):
			dir = -dir;
