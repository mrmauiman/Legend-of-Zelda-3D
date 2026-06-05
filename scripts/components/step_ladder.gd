extends StaticBody3D

var waters = [];
var subtractors = [];

func _on_water_displacer_body_entered(body):
	if not body.is_in_group("Water"):
		return;
	
	var water = body.get_parent();
	if water in waters: return;
	var subtractor: CSGBox3D = %Subtractor.duplicate();
	subtractor.operation = CSGShape3D.OPERATION_SUBTRACTION;
	water.add_child(subtractor);
	call_deferred("cut_out",water, subtractor);

func cut_out(water, subtractor):
	water.visible = true;
	subtractor.visible = true;
	subtractor.global_position = global_position + subtractor.position;
	water.update_collision_shape();
	water.visible = false;
	subtractor.visible = false;
	waters.push_back(water);
	subtractors.push_back(subtractor);

func _exit_tree():
	for subtractor in subtractors:
		if subtractor:
			subtractor.queue_free();
	
	for water in waters:
		if water:
			water.clear_cutouts();


func _on_water_displacer_body_exited(body):
	if body.is_in_group("Link"):
		queue_free();
