class_name GleeokHead extends Enemy

@export var neck_point: Node3D;

@onready var gleeok: Gleeok = get_parent();
@onready var animation_player: AnimationPlayer = get_node("ColorAnimationPlayer");
@onready var health: Health = get_node("Health");

func play_hurt_animation():
	animation_player.play("hurt");

func update_held_item():
	pass;

func _physics_process(_delta):
	move_and_slide();

const HEAD_SCENE: PackedScene = preload("res://scenes/enemies/dungeon/gleeok_head_dettached.tscn");

func spawn_floating_head():
	var head = HEAD_SCENE.instantiate();
	head.position = position;
	gleeok.add_child(head);

func die():
	gleeok.remove_head();
	spawn_floating_head();
	super();
