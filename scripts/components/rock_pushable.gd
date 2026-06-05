extends StaticBody3D

var pushed = false;

@onready var push_detector: Area3D = $Area3D;
@export var door: Node3D;
@export var power_bracelet_required: bool = false;

func _physics_process(_delta):
	if pushed: return;
	if power_bracelet_required and Inventory.items.power_bracelet == Inventory.ITEM_TYPES.NONE: return;
	for body in push_detector.get_overlapping_bodies():
		if body.is_in_group("Link") and body.state != body.STATES.PUSH:
			var push_dir = (global_position - body.global_position);
			push_dir = Vector3(0, 0, push_dir.z).normalized();
			if body.is_pushing(push_dir):
				body.push(self, push_dir);

func handle_pushed():
	pushed = true;
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
	door.destroy();
