extends ShapeCast3D

@export var link: CharacterBody3D;

func _physics_process(_delta):
	if not link: return;
	
	var link_vel = link.move_dir;
	link_vel.y = 0;
	
	if link_vel.length() > 0:
		var goal_pos = link.global_position + link_vel
		look_at(goal_pos);
