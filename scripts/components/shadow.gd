@tool
extends Node3D

const SHADER_RES: Shader = preload("res://shaders/shadow.gdshader");

@export_range(0.3, 1.6, 0.1) var shadow_radius: float = 0.5;

@onready var ray = %RayCast3D;
@onready var shadow = %ShadowContainer;
@onready var mesh = %ShadowContainer/Shadow;
@onready var shadow_shader : ShaderMaterial = mesh.material_override;

func _ready():
	shadow_shader.set_shader_parameter("radius", shadow_radius * 10);
	if not Engine.is_editor_hint():
		shadow_shader = ShaderMaterial.new();
		shadow_shader.shader = SHADER_RES;
		mesh.material_override = shadow_shader;
		shadow_shader.set_shader_parameter("radius", shadow_radius * 10);
		shadow_shader.set_shader_parameter("transparency", 0.4);

func _physics_process(_delta):
	if Engine.is_editor_hint():
		shadow_shader.set_shader_parameter("radius", shadow_radius * 10);
	if ray.is_colliding():
		var point = ray.get_collision_point()
		shadow.position = to_local(point + Vector3(0, 0.1, 0));
		shadow.look_at(point + ray.get_collision_normal(), Vector3.FORWARD)
	else:
		shadow.position = ray.position;
		shadow.look_at(shadow.global_position + Vector3.UP, Vector3.FORWARD);
