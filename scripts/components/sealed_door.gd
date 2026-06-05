extends StaticBody3D

@export var enemies: Node3D;

var unlocked = false;

func destroy():
	queue_free();

func unlock():
	SoundSystem.play_global("res://audio/sfx/door_opened.wav");
	unlocked = true;
	visible = false;
	%CollisionShape3D.set_deferred("disabled", true);

func lock():
	SoundSystem.play_global("res://audio/sfx/door_opened.wav");
	unlocked = false;
	visible = true;
	%CollisionShape3D.set_deferred("disabled", false);

func _ready():
	unlock();


func _process(_delta):
	if not unlocked and enemies:
		if enemies.get_child_count() <= 0:
			unlock();


func _on_body_entered(body):
	if body.is_in_group("Link") and unlocked:
		lock();
