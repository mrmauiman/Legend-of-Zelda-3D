class_name Moldorm extends Enemy

@export var head: Moldorm;
@export var move_speed: float = 4.8;
@export var change_dir_chance: float = 45;
@export var change_dir_check_time: float = 1;
@export var turn_speed: float = 180;

@onready var health: Health = $Health;
@onready var hurt_anim: AnimationPlayer = $HurtAnimation;

var dir := Vector2(0, 1);
var goal_dir := dir;
var timer: float = 0;

func update_held_item():
	pass;

func change_dir():
	goal_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized();
	if goal_dir == Vector2.ZERO: goal_dir = Vector2.DOWN;

func update_dir(delta):
	timer -= delta;
	if timer <= 0:
		if randf_range(1, 100) <= change_dir_chance:
			change_dir();
		timer += change_dir_check_time;

	if dir.is_equal_approx(goal_dir): return;

	var diff = dir.angle_to(goal_dir);
	var turn_amount = sign(diff) * deg_to_rad(turn_speed) * delta;
	if abs(turn_amount) > abs(diff): turn_amount = diff;

	dir = dir.rotated(turn_amount)

func _physics_process(delta):
	if head:
		velocity = (head.global_position - global_position).normalized() * move_speed;
	else:
		update_dir(delta);
		velocity = Vector3(dir.x, 0, dir.y).normalized() * move_speed;
	
	velocity.y = 0;

	move_and_slide();

	if not head:
		var collision := get_last_slide_collision();
		if collision and collision.get_collider():# and not collision.get_collider() is Moldorm:
			if not collision.get_collider() is Moldorm:
				var norm = Vector2(collision.get_normal().x, collision.get_normal().z).normalized();
				dir = dir.bounce(norm);
			else:
				dir = Vector2(collision.get_normal().x, collision.get_normal().z).normalized();
			goal_dir = dir;
	


func _on_hurt_box_area_entered(area: Area3D):
	if area is HitBox:
		var hb: HitBox = area;
		hurt_anim.play("hurt");
		health.take_damage(hb.get_damage());
		if health.is_dead():
			die();
