extends HealPickup

enum STATES {SPAWNING, PATROL, HURT, STUNNED};
var state: STATES = STATES.SPAWNING;

@export var turn_chance: float = 35;
@export var move_speed: float = 6.4;

@onready var wall_checks = %WallChecks;

var move_dir = Vector3.ZERO;

var timer: float = 1;
var stun_timer: float = 0;

func change_dir() -> bool:
	return randf_range(0, 100) <= turn_chance;

func get_move_dir():
	var available = [];
	for check: RayCast3D in wall_checks.get_children():
		if not check.is_colliding():
			available.push_back(check.target_position);
	var dir = available.pick_random().normalized();
	
	dir.y = randf_range(-5, 2);
	dir.y = clamp(dir.y, -1, 1);
	
	return dir;

func patrol_process(delta):
	timer -= delta;
	if timer <= 0:
		if change_dir(): move_dir = get_move_dir();
		timer = 1;
	
	var look_dir = move_dir;
	look_dir.y = 0;
	if look_dir.length() > 0:
		look_at(global_position - look_dir.normalized());
	
	velocity = move_dir * move_speed;
	if not %FloorCheck.is_colliding():
		velocity.y = min(velocity.y, 0);

func _ready():
	if Engine.is_editor_hint():
		wall_checks.position = global_position;
		return;
	move_dir = get_move_dir();
	super();


func _physics_process(delta):
	if Engine.is_editor_hint():
		wall_checks.position = global_position;
		return;
	
	wall_checks.position = global_position;
	
	patrol_process(delta);
	
	move_and_slide();
	
	var last_collision = get_last_slide_collision();
	if last_collision and last_collision.get_normal().angle_to(Vector3.UP) > deg_to_rad(5):
		move_dir = get_move_dir();
