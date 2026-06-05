extends State

@export var dash_speed: float = 9.6;

@onready var hitbox: CollisionShape3D = $HitBox/CollisionShape3D;

func enter(_previous_state: State, _params: Array):
	hitbox.set_deferred("disabled", false);
	character.animation_player.play("dash")

func exit(_new_state: State):
	hitbox.set_deferred("disabled", true);

func update(_delta):
	pass;

func physics_update(_delta):
	var forward = global_transform.basis.z.normalized() * dash_speed;
	character.velocity.x = forward.x;
	character.velocity.z = forward.z;

	if character.is_on_wall():
		state_machine.change_state("Patrol");
