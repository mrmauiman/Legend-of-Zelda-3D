class_name PatraDrone extends Enemy

@onready var model: Node3D = %Model;
@onready var color_animation_player: AnimationPlayer = model.get_node("%ColorAnimationPlayer");
@onready var health: Health = %Health;

func update_held_item():
	pass;

func _physics_process(_delta):
	move_and_slide();

func _on_hurt_box_area_entered(area):
	if area is HitBox and area.is_sword:
		var hitbox: HitBox = area;
		color_animation_player.play("hurt");
		health.take_damage(hitbox.get_damage(false));
		hitbox.hit.emit(self);
		if health.is_dead():
			die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
