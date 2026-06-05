extends Area3D

@export var teleport_to: Vector3;
@export var look_dir: Vector3;

@export var is_fast_travel_door: bool = false;

@export_group("Change Level")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Change Level") var change_level: bool = false;
@export var change_to: Inventory.LEVELS = Inventory.LEVELS.OVERWORLD;

const LOCAL_TELEPORT_OFFSET: Vector3 = Vector3(12.8, -12.7, -4);
const MAP_SET_OFFSET: Vector3 = Vector3(12.8, 0, -8.8);

var link;

func _ready():
	DoorAnimation.anim_finished.connect(_animation_finished);

func _animation_finished(anim):
	if anim == "enter" and link:
		if Inventory.current_level == Inventory.LEVELS.OVERWORLD:
			if teleport_to.y > -10: SoundSystem.play_overworld_music();
		link.look_in_dir(look_dir);
		link.visible = true;
		link.enable_hurtbox();
		DoorAnimation.exit();
		if not is_fast_travel_door:
			link.global_position = teleport_to;
		else:
			link.global_position = teleport_to + MAP_SET_OFFSET;
			link.set_deferred("global_position", teleport_to + LOCAL_TELEPORT_OFFSET);
			if Inventory.current_level == Inventory.LEVELS.OVERWORLD:
				SoundSystem.call_deferred("stop_music");
		link = null;

func _on_body_entered(body):
	if body.is_in_group("Link"):
		link = body;
		link.visible = false;
		link.disable_hurtbox();
		DoorAnimation.enter();
		if Inventory.current_level == Inventory.LEVELS.OVERWORLD:
			SoundSystem.stop_music();
		SoundSystem.play_global("res://audio/sfx/UsingStairs.wav");
		if change_level:
			Inventory.current_level = change_to;
