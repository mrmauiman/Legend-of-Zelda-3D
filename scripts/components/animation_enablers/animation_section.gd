class_name AnimationSection extends Resource

@export var animation: String = "";
@export var start_time: float = 0;
@export var end_time: float =  0;

func _init():
	animation = "";
	start_time = 0;
	end_time = 0;