extends CSGBox3D

var base_shape: BoxShape3D;

func update_collision_shape():
	visible = true;
	var shape = bake_collision_shape();
	%BodyShape.shape = shape;
	visible = false;

func clear_cutouts():
	%BodyShape.shape = base_shape;

func _ready():
	base_shape = BoxShape3D.new();
	base_shape.size = size;
	%BodyShape.shape = base_shape;
