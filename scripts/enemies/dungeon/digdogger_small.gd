extends Enemy

@export var move_speed: float = 8;

@onready var model = get_node("%Model");
@onready var color_animation_player: AnimationPlayer = model.get_node("%ColorAnimationPlayer");
@onready var health: Health = get_node("%Health");

const GRAVITY = 64;

var dir = Vector3.RIGHT;
var iframe_timer = 0;

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

func _physics_process(delta):
	iframe_timer -= delta;
	
	velocity.y -= GRAVITY * delta;
	
	var y_vel = velocity.y;
	velocity = dir * move_speed;
	velocity.y = y_vel;
	
	move_and_slide();
	
	if is_on_wall():
		var wall_norm = get_wall_normal();
		if wall_norm.angle_to(-dir) < deg_to_rad(45):
			dir = dir.bounce(wall_norm);


func _on_hurt_box_area_entered(area):
	if area is HitBox and iframe_timer <= 0:
		var hitbox: HitBox = area;
		color_animation_player.play("hurt");
		health.take_damage(hitbox.get_damage(false));
		hitbox.hit.emit(self);
		if health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
