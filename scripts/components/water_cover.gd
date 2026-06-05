extends MeshInstance3D

var link;

func _ready():
	if Inventory.level_7_revealed:
		queue_free();

func _process(_delta):
	if link and link.state == link.STATES.FLUTE:
		link.flute_input_used = true;
		Inventory.level_7_revealed = true;
		SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
		queue_free();

func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("Link"):
		link = body;

func _on_area_3d_body_exited(body: Node3D):
	if body.is_in_group("Link"):
		link = null;
