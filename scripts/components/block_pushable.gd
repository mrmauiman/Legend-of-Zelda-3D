extends StaticBody3D

var pushed = false;

@onready var push_detector: Area3D = $Area3D;
@export var door: Node3D;
@export var extra_doors: Array[Node3D] = [];
@export var power_bracelet_required: bool = false;

@export var x_axis_locked: bool = false;
@export var z_axis_locked: bool = false;

func _ready():
	if x_axis_locked:
		%"X-Axis".disabled = true;
	if z_axis_locked:
		%"Z-Axis".disabled = true;

func handle_pushed():
	pushed = true;
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
	if door:
		door.destroy();
	for dr in extra_doors:
		dr.destroy();


func _physics_process(_delta):
	if pushed: return;
	if power_bracelet_required and Inventory.items.power_bracelet == Inventory.ITEM_TYPES.NONE: return;
	for body in push_detector.get_overlapping_bodies():
		if body.is_in_group("Link") and body.state != body.STATES.PUSH:
			var push_dir = (global_position - body.global_position);
			if z_axis_locked or abs(push_dir.x) > abs(push_dir.z):
				push_dir = Vector3(push_dir.x, 0, 0).normalized();
			else:
				push_dir = Vector3(0, 0, push_dir.z).normalized();
			if body.is_pushing(push_dir):
				body.push(self, push_dir);
