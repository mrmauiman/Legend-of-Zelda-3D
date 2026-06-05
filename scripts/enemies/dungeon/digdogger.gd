extends Enemy

enum SPLIT_COUNTS {ONE, THREE};

@export var move_speed: float = 4.8;
@export var split_count: SPLIT_COUNTS = SPLIT_COUNTS.ONE;

const GRAVITY = 64;

var dir = Vector3.RIGHT;

func update_held_item():
	pass;

func set_rand_dir():
	while true:
		dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1));
		if dir != Vector3.ZERO:
			break;
	dir = dir.normalized();

func _ready():
	set_rand_dir();
	
	Inventory.recorded_played.connect(split);

var roar_timer: float = 2.5;
func _physics_process(delta):
	roar_timer -= delta;
	if roar_timer <= 0:
		SoundSystem.play_global("res://audio/sfx/boss_roar.wav");
		roar_timer = 2.5;
	velocity.y -= GRAVITY * delta;
	
	var y_vel = velocity.y;
	velocity = dir * move_speed;
	velocity.y = y_vel;
	
	move_and_slide();
	
	if is_on_wall():
		var wall_norm = get_wall_normal();
		if wall_norm.angle_to(-dir) < deg_to_rad(45):
			dir = dir.bounce(wall_norm);

const DIGDOGGER_SMALL_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/digdogger_small.tscn");

func split():
	SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
	var spawn_points = [];
	match split_count:
		SPLIT_COUNTS.ONE:
			spawn_points.push_back(get_node("%SpawnPoint1"));
		SPLIT_COUNTS.THREE:
			spawn_points.append_array(get_node("%SpawnPoints3").get_children());
	
	for spawn_point in spawn_points:
		var digdogger_small = DIGDOGGER_SMALL_SCENE.instantiate();
		digdogger_small.position = position + spawn_point.position;
		get_parent().add_child(digdogger_small);
	
	queue_free();
