extends Node3D

@onready var manhandla: Manhandla = get_parent();

func _process(_delta):
	var i = 1;
	for head in manhandla.heads:
		get_node("%MouthOpen/Mouth"+str(i)).visible = head;
		get_node("%MouthClosed/Mouth"+str(i)).visible = head;
		i+=1;
