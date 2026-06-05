class_name LoadableManager extends Node3D

var pickups;
var sealed_doors;
var spawn_checker;
var enemies;
var bosses;

var link_pos;

func get_room_name():
	return get_parent().name.to_lower();

func should_respawn_enemies() -> bool:
	var room_name = get_room_name();
	var data = EnemyTracker.dungeons[Inventory.current_level][room_name];
	
	# Check have visited several other unique rooms
	var visited_recently = EnemyTracker.dungeon_room_visited_recently(room_name);
	if visited_recently: return false;
	
	# Check all enemies dead
	for enemy in enemies.get_children():
		if not data.enemies[enemy.name]:
			return false;
	
	return true;

func _ready():
	if has_node("Pickups"): pickups = get_node("Pickups");
	if has_node("SealedDoors"): sealed_doors = get_node("SealedDoors");
	if has_node("SpawnChecker"): spawn_checker = get_node("SpawnChecker");
	if has_node("Enemies"): enemies = get_node("Enemies");
	if has_node("Bosses"): bosses = get_node("Bosses");

	var data = {};
	var room_name = get_room_name();
	var name_str = str(name).to_lower();

	if EnemyTracker.dungeons[Inventory.current_level].has(room_name):
		data = EnemyTracker.dungeons[Inventory.current_level][room_name];
	else:
		if pickups:
			data.pickups = {};
			for pickup in pickups.get_children():
				data.pickups[pickup.name] = false;
		if enemies:
			data.enemies = {};
			var i = 0;
			for enemy in Randomizer.dungeon_enemy_map[Inventory.current_level][name_str]:
				var enemy_name = enemy+str(i);
				data.enemies[enemy_name] = false;
				i+=1;
		if bosses:
			data.bosses = {};
			for boss in bosses.get_children():
				data.bosses[boss.name] = false;
		EnemyTracker.dungeons[Inventory.current_level][room_name] = data;
	
	if pickups:
		for pickup in pickups.get_children():
			if data.pickups[pickup.name]: pickup.queue_free();
	
	if enemies:
		var i = 0;
		var respawn = should_respawn_enemies();
		for enemy_type in Randomizer.dungeon_enemy_map[Inventory.current_level][name_str]:
			var enemy_name = enemy_type+str(i);
			if respawn or not data.enemies[enemy_name]:
				var enemy_scene = load("res://scenes/enemies/dungeon/"+enemy_type+".tscn");
				var enemy_node = enemy_scene.instantiate();
				enemy_node.name = enemy_name;
				enemies.add_child(enemy_node);
			i+=1;
	
	if bosses:
		for boss in bosses.get_children():
			if data.bosses[boss.name]: boss.queue_free();
	
	if sealed_doors:
		for sealed_door in sealed_doors.get_children():
			sealed_door.lock();

func _exit_tree():
	var room_name = get_room_name()
	var data = EnemyTracker.dungeons[Inventory.current_level][room_name];
	if pickups:
		for pickup_name in data.pickups:
			EnemyTracker.dungeons[Inventory.current_level][room_name].pickups[pickup_name] = not pickups.has_node(str(pickup_name));
	if enemies:
		for enemy_name in data.enemies:
			EnemyTracker.dungeons[Inventory.current_level][room_name].enemies[enemy_name] = not enemies.has_node(str(enemy_name));
	if bosses:
		for boss_name in data.bosses:
			EnemyTracker.dungeons[Inventory.current_level][room_name].bosses[boss_name] = not bosses.has_node(str(boss_name));
