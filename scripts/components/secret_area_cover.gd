@tool
extends MeshInstance3D

@export var shader: ShaderMaterial;

@export var link_inside: bool = false:
	set(val):
		link_inside = val;
		if link_inside:
			on_enter();

var disolve_timer: float = 1.0;


func on_enter():
	set_surface_override_material(0, shader);
	shader.set_shader_parameter("disolve", true);
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");

func _process(delta):
	if link_inside:
		disolve_timer = max(0, disolve_timer - delta);
	else:
		disolve_timer = min(1, disolve_timer + delta);
		if disolve_timer == 1:
			shader.set_shader_parameter("disolve", false);
			set_surface_override_material(0, null);
	shader.set_shader_parameter("background_threshold", disolve_timer);


func _on_area_3d_body_entered(body):
	if body.is_in_group("Link"):
		link_inside = true;


func _on_area_3d_body_exited(body):
	if body.is_in_group("Link"):
		link_inside = false;
