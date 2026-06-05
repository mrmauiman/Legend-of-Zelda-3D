extends Area3D

var link_inside: bool = false;

@export var path = ["north", "west", "south", "west"];
@export var exit = "east";
@export var teleport_offsets = {
	"north": Vector3(0, 0, 16),
	"west": Vector3(24, 0, 0),
	"east": Vector3(-24, 0, 0),
	"south": Vector3(0, 0, -16),
};

var taken = ["none", "none", "none", "none"];

func check_path(link):
	if taken == path:
		SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
		return;
	
	var dir = taken[-1];
	if dir == exit:
		return;
	
	link.position += teleport_offsets[dir];

func _on_body_entered(body):
	if body.is_in_group("Link"):
		link_inside = true;
		%CollisionShape3D.shape.size.x = 25.6;
		%CollisionShape3D.shape.size.z = 17.6;
		%FogWalls.visible = true;


func _on_body_exited(body):
	if body.is_in_group("Link"):
		link_inside = false;
		%CollisionShape3D.shape.size.x = 22.4;
		%CollisionShape3D.shape.size.z = 14.4;
		%FogWalls.visible = false;

func enter_dir(body, dir):
	if link_inside and body.is_in_group("Link"):
		taken.push_back(dir);
		taken.pop_front();
		check_path(body);
	elif not body.is_in_group("Link"):
		body.queue_free();
