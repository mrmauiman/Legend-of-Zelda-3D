extends Node3D

@export_multiline var info: String;

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.change_text(info);
		%Text.reveal = true;
