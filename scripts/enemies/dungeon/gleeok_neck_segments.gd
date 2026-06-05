@tool
extends Node3D

@onready var head: GleeokHead = get_parent();

func update_neck_position(delta):
	var segment_count = get_child_count()+1.0;
	var i = 1.0;
	for segment in get_children():
		var goal_pos = head.global_position.lerp(head.neck_point.global_position, i/segment_count);
		segment.global_position = segment.global_position.lerp(goal_pos, min(((i/segment_count))*delta*25, 1));
		i+=1;

func _physics_process(delta):
	if head.neck_point:
		update_neck_position(delta);
