extends Area3D

var lanmola: Lanmola = get_parent().get_parent().get_parent();
var model = lanmola.get_node("Model");

func _physics_process(_delta):
	for shape: CollisionShape3D in get_children():
		var body_piece = model.get_node("BodyPiece" + shape.name.substr(-1));
		shape.global_position = body_piece.global_position;
