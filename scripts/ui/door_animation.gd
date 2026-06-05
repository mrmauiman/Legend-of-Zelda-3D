extends CanvasLayer

@onready var shader: ShaderMaterial = $ColorRect.material;

signal anim_finished(anim: String);

func _ready():
	$AnimationPlayer.animation_finished.connect(_animation_finished);

func _animation_finished(anim):
	anim_finished.emit(anim);

func set_circle_radius(val: float):
	shader.set_shader_parameter("circle_radius", val);

func enter():
	$AnimationPlayer.play("enter");

func exit():
	$AnimationPlayer.play("exit");
