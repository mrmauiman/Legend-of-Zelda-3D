extends CharacterBody3D

enum STATES {IDLE, ATTACK, RETURNING};

@export var attack_speed: float = 10.8;
@export var return_speed: float = 3.2;

var state: STATES = STATES.IDLE;

var starting_pos = Vector3.ZERO;
var attack_ray: ShapeCast3D;

func _ready():
	starting_pos = global_position;

func check_sights():
	for sight: ShapeCast3D in %Sights.get_children():
		if sight.is_colliding():
			for i in range(sight.get_collision_count()):
				var obj = sight.get_collider(i);
				if obj and obj.is_in_group("Link"):
					state = STATES.ATTACK;
					attack_ray = sight;

func _physics_process(_delta):
	match state:
		STATES.IDLE:
			velocity = Vector3.ZERO;
			check_sights();
		STATES.ATTACK:
			velocity = (attack_ray.target_position.normalized()) * attack_speed;
			move_and_slide();
			if attack_ray.get_node("CollisionCheck").is_colliding():
				state = STATES.RETURNING;
		STATES.RETURNING:
			var return_dir = (starting_pos - global_position).normalized();
			velocity = return_dir * return_speed;
			move_and_slide();
			if (global_position - starting_pos).length() < 0.2:
				global_position = starting_pos;
				state = STATES.IDLE;
