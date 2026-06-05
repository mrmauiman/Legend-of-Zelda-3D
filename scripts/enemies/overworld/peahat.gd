extends Enemy

@onready var animation_player: AnimationPlayer = %PeahatModel/AnimationPlayer;

## Maximum speed the peahat will spin in degrees per second.
@export var max_spin_speed: float = 720;
@export var spin_acceleration: float = 720;
@export var rising_speed: float = 6.4;
@export var move_speed: float = 9.6;
@export var min_flight_time: float = 2;
@export var max_flight_time: float = 5;

enum STATES {IDLE, FLYING, LANDING, STUNNED, SPAWNING};
var state = STATES.IDLE;

var spin_speed = 0;
var timer = 0;
var stun_timer = 0;

const LINK_PROXIMITY_NULLIFICATION: float = 4.8;

@onready var screen = get_parent().get_parent();
@onready var spawn_checker: SpawnChecker = screen.get_node("SpawnChecker")


func update_held_item():
	pass

func spawned():
	state = STATES.IDLE;

func idle_process(delta):
	velocity = Vector3.ZERO;
	timer -= delta;
	if timer <= 0:
		state = STATES.FLYING;

func flying_process(delta):
	var is_max_speed = spin_speed == max_spin_speed;
	if not is_max_speed:
		spin_speed = min(spin_speed + (spin_acceleration * delta), max_spin_speed);
	%PeahatModel.rotation_degrees.y += spin_speed * delta;
	if not is_max_speed: 
		velocity.y = 0;
		return;
	if %GroundCheck.is_colliding():
		velocity.y = rising_speed;
	else:
		velocity.y = 0;
		if velocity.length() == 0:
			velocity.x = randf_range(-1, 1);
			velocity.z = randf_range(-1, 1);
			velocity = velocity.normalized() * move_speed;
			timer = randf_range(min_flight_time, max_flight_time);
		timer -= delta;
		if timer <= 0:
			state = STATES.LANDING;
			velocity = Vector3.ZERO;
		else:
			var rays = %WallChecks.get_children()
			for check: RayCast3D in rays:
				if check.is_colliding():
					var available_ranges = [[-180, 180]];
					for ray: RayCast3D in rays:
						if ray.is_colliding():
							available_ranges = get_available_ranges(available_ranges, [ray.rotation_degrees.y - 89, ray.rotation_degrees.y + 89]);
					var angle = get_random_angle(available_ranges);
					velocity = Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(angle)) * move_speed;

func get_random_angle(available_ranges):
	var amount = 0;
	for curr_range in available_ranges:
		amount += curr_range[1] - curr_range[0];
	var r = randf_range(0, amount);
	for curr_range in available_ranges:
		var step = curr_range[1] - curr_range[0];
		if r > step:
			r -= step;
		else:
			return curr_range[0] + r;
	print("something went wrong");
	return 0;


func get_available_ranges(available_ranges, exclude_range):
	var rv = [];
	for curr_range in available_ranges:
		var min_inside = exclude_range[0] > curr_range[0];
		var max_inside = exclude_range[1] < curr_range[1];
		if min_inside and max_inside:
			rv.push_back([curr_range[0], exclude_range[0]-1]);
			rv.push_back([exclude_range[1]+1, curr_range[1]]);
		elif min_inside:
			rv.push_back([curr_range[0], exclude_range[0]-1]);
		elif max_inside:
			rv.push_back([exclude_range[1]+1, curr_range[1]]);
		else:
			rv.push_back(curr_range);
	return rv;

func landing_process(delta):
	velocity = Vector3.DOWN * rising_speed;
	if spin_speed > 0:
		spin_speed = max(spin_speed - (spin_acceleration * delta), 0);
		%PeahatModel.rotation_degrees.y += spin_speed * delta;
	elif is_on_floor():
		state = STATES.IDLE;
		timer = randf_range(min_flight_time, max_flight_time);

func stunned_process(delta):
	stun_timer -= delta;
	if stun_timer <= 0:
		state = STATES.IDLE;
	velocity = Vector3.ZERO;

func _ready():
	timer = randf_range(min_flight_time, max_flight_time);

func _physics_process(delta):
	
	if state == STATES.SPAWNING: return;
	
	if clock_stun: 
		velocity = Vector3.DOWN * 64;
		move_and_slide();
		return;

	match state:
		STATES.IDLE:
			idle_process(delta);
		STATES.FLYING:
			flying_process(delta);
		STATES.LANDING:
			landing_process(delta);
		STATES.STUNNED:
			stunned_process(delta);
	
	move_and_slide();


func _on_hurt_box_area_entered(area):
	if area is HitBox:
		var hitbox: HitBox = area;
		animation_player.play("hurt");
		var knockback = hitbox.knockback;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			dir.y = 0;
			var xz_knockback = xz_speed * dir.normalized();
			knockback = Vector3(xz_knockback.x, hitbox.knockback.y, xz_knockback.z);
		elif hitbox.relative_knockback_orientor:
			var orientor_forward = -hitbox.relative_knockback_orientor.global_transform.basis.z;
			var orientor_right = hitbox.relative_knockback_orientor.global_transform.basis.x;
			knockback = (orientor_forward * knockback.z) + (orientor_right * knockback.x) + (Vector3.UP * knockback.y);
		velocity = knockback;
		if hitbox.stun_time > 0:
			state = STATES.STUNNED;
			stun_timer = hitbox.stun_time;
		%Health.take_damage(hitbox.get_damage());
		hitbox.hit.emit(self);
		if %Health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
