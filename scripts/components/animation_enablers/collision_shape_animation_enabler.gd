extends AnimationEnabler

@onready var collision_shape: CollisionShape3D = get_parent();

func enable():
	collision_shape.set_deferred("disabled", false);

func disable():
	collision_shape.set_deferred("disabled", true);
