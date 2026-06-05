extends Node3D

@export var linger_time: float = 1.5;

var timer: float = 0;

func _process(delta):
	var total_frames = %SmokeModel.hframes * %SmokeModel.vframes;
	timer += delta
	%SmokeModel.frame = floori((timer/linger_time) * total_frames);
	if timer >= linger_time:
		queue_free();
