extends Node

enum ENEMY_GROUPS {A, B, C, D, X};
enum DROPS {NONE, RUPEE, HEART, BOMB, FAIRY, CLOCK, RUPEE_5};

const DROP_CHART = {
	0: {
		ENEMY_GROUPS.A: DROPS.RUPEE,
		ENEMY_GROUPS.B: DROPS.BOMB,
		ENEMY_GROUPS.C: DROPS.RUPEE,
		ENEMY_GROUPS.D: DROPS.HEART
	},
	1: {
		ENEMY_GROUPS.A: DROPS.HEART,
		ENEMY_GROUPS.B: DROPS.RUPEE,
		ENEMY_GROUPS.C: DROPS.HEART,
		ENEMY_GROUPS.D: DROPS.FAIRY
	},
	2: {
		ENEMY_GROUPS.A: DROPS.RUPEE,
		ENEMY_GROUPS.B: DROPS.CLOCK,
		ENEMY_GROUPS.C: DROPS.RUPEE,
		ENEMY_GROUPS.D: DROPS.RUPEE
	},
	3: {
		ENEMY_GROUPS.A: DROPS.FAIRY,
		ENEMY_GROUPS.B: DROPS.RUPEE,
		ENEMY_GROUPS.C: DROPS.RUPEE_5,
		ENEMY_GROUPS.D: DROPS.HEART
	},
	4: {
		ENEMY_GROUPS.A: DROPS.RUPEE,
		ENEMY_GROUPS.B: DROPS.HEART,
		ENEMY_GROUPS.C: DROPS.HEART,
		ENEMY_GROUPS.D: DROPS.FAIRY
	},
	5: {
		ENEMY_GROUPS.A: DROPS.HEART,
		ENEMY_GROUPS.B: DROPS.BOMB,
		ENEMY_GROUPS.C: DROPS.CLOCK,
		ENEMY_GROUPS.D: DROPS.HEART
	},
	6: {
		ENEMY_GROUPS.A: DROPS.HEART,
		ENEMY_GROUPS.B: DROPS.RUPEE,
		ENEMY_GROUPS.C: DROPS.RUPEE,
		ENEMY_GROUPS.D: DROPS.HEART
	},
	7: {
		ENEMY_GROUPS.A: DROPS.RUPEE,
		ENEMY_GROUPS.B: DROPS.BOMB,
		ENEMY_GROUPS.C: DROPS.RUPEE,
		ENEMY_GROUPS.D: DROPS.HEART
	},
	8: {
		ENEMY_GROUPS.A: DROPS.RUPEE,
		ENEMY_GROUPS.B: DROPS.HEART,
		ENEMY_GROUPS.C: DROPS.RUPEE,
		ENEMY_GROUPS.D: DROPS.RUPEE
	},
	9: {
		ENEMY_GROUPS.A: DROPS.HEART,
		ENEMY_GROUPS.B: DROPS.HEART,
		ENEMY_GROUPS.C: DROPS.RUPEE_5,
		ENEMY_GROUPS.D: DROPS.HEART
	}
}

var counter: int = 0;

var combo_counter: int = 0;

func increment():
	counter += 1;
	if counter == 10: counter = 0;

func reset_combo():
	combo_counter = 0;

func get_drop(group: ENEMY_GROUPS, bomb_kill: bool = false):
	var curr_count = counter;
	increment();
	
	if group != ENEMY_GROUPS.X:
		combo_counter += 1;
		if combo_counter == 10:
			if bomb_kill: return DROPS.BOMB;
			return DROPS.RUPEE_5;
		if combo_counter == 16:
			return DROPS.FAIRY;
	
	match group:
		ENEMY_GROUPS.A:
			if randi_range(1, 256) <= 80:
				return DROP_CHART[curr_count][group];
			return DROPS.NONE;
		ENEMY_GROUPS.B:
			if randi_range(1, 256) <= 104:
				return DROP_CHART[curr_count][group];
			return DROPS.NONE;
		ENEMY_GROUPS.C:
			if randi_range(1, 256) <= 152:
				return DROP_CHART[curr_count][group];
			return DROPS.NONE;
		ENEMY_GROUPS.D:
			if randi_range(1, 256) <= 104:
				return DROP_CHART[curr_count][group];
			return DROPS.NONE;
		ENEMY_GROUPS.X:
			return DROPS.NONE;

#{NONE, RUPEE, HEART, BOMB, FAIRY, CLOCK, RUPEE_5};
const RUPEE_SCENE: PackedScene = preload("res://scenes/pickups/rupee_pickup.tscn");
const RUPEE_5_SCENE: PackedScene = preload("res://scenes/pickups/rupee_5_pickup.tscn");
const HEART_SCENE: PackedScene = preload("res://scenes/pickups/heart_pickup.tscn");
const BOMB_SCENE: PackedScene = preload("res://scenes/pickups/bomb_pickup.tscn");
const FAIRY_SCENE: PackedScene = preload("res://scenes/pickups/fairy_pickup.tscn");
const CLOCK_SCENE: PackedScene = preload("res://scenes/pickups/clock_pickup.tscn");

func spawn_drop(drop: DROPS, spawn_location: Vector3):
	var pickup;
	match drop:
		DROPS.RUPEE:
			pickup = RUPEE_SCENE.instantiate();
		DROPS.RUPEE_5:
			pickup = RUPEE_5_SCENE.instantiate();
		DROPS.HEART:
			pickup = HEART_SCENE.instantiate();
		DROPS.BOMB:
			pickup = BOMB_SCENE.instantiate();
		DROPS.FAIRY:
			pickup = FAIRY_SCENE.instantiate();
		DROPS.CLOCK:
			pickup = CLOCK_SCENE.instantiate();
		DROPS.NONE:
			return;
	pickup.position = spawn_location;
	pickup.boomerang_can_pickup = true;
	get_tree().root.add_child(pickup);
