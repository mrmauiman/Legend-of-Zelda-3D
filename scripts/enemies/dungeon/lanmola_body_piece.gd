extends Enemy

@onready var color_animation_player: AnimationPlayer = get_node("ColorAnimationPlayer");
@onready var health: Health = get_node("Health");

@export var parent: Node3D;
@export var move_speed: float = 5;

var iframe_timer: float = 0;

func update_held_item():
	pass;

func _ready():
	if not parent:
		printerr("Parent not set on lanmola body piece!");
		queue_free();
	
	await get_tree().create_timer(0.1, true).timeout;
	global_position = parent.global_position;

func _physics_process(delta):
	if iframe_timer > 0:
		iframe_timer -= delta;
	
	if not parent:
		die();
		return;
	var offset_dir = parent.global_transform.basis.z.normalized();
	if parent is Lanmola: offset_dir *= -1;
	var goal_pos = parent.global_position + (offset_dir * 0.8);
	var dir = (goal_pos - global_position).normalized();
	look_at(parent.global_position);
	velocity = dir * move_speed;
	velocity.y = 0;
	move_and_slide();


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
