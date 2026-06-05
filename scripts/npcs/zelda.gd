extends Node3D

var link;
var game_ended: bool = false;

@onready var top_text: Label3D = %Text;
@onready var bottom_text: Label3D = %Text2;
@onready var middle_text: Label3D = %Text3;

func _ready():
	top_text.visible = true;
	bottom_text.visible = true;
	middle_text.visible = true;

func start_ending():
	link.global_position = global_position + Vector3(1.6, 0, 0);
	look_at(global_position - Vector3(1.6, 0, 0));
	link.touch_zelda(self);
	SoundSystem.play_triforce_music();
	SoundSystem.triforce_music.finished.connect(transition_to_final_text);

func transition_to_final_text():
	DoorAnimation.enter();
	var thank_you_str: String = top_text.original_text;
	var name_inserted: String = thank_you_str.replace("{NAME}", Inventory.link_name);
	top_text.original_text = name_inserted;
	top_text.reveal = true;
	top_text.reveal_complete.connect(hold_triforce_aloft);

func hold_triforce_aloft():
	$Model/Pose1.visible = false;
	$Model/Pose2.visible = true;
	var icon_data = Inventory.get_icon.triforce_piece[Inventory.ITEM_TYPES.NONE];
	link.pickup_sprite.texture = icon_data.texture;
	link.pickup_sprite.hframes = icon_data.hframes;
	link.pickup_sprite.vframes = icon_data.vframes;
	link.pickup_sprite.frame = icon_data.frame;
	link.animation_player.play("pickup_triforce_piece");
	bottom_text.reveal = true;
	link.animation_player.animation_finished.connect(link_anim_finished);

func link_anim_finished(anim):
	if anim == "pickup_triforce_piece":
		end_game();

func end_game():
	link.model.visible = false;
	$Model.visible = false;
	game_ended = true;
	middle_text.reveal = true;
	PauseMenu.get_node("MarginContainer").locked = true;

func _process(_delta):
	if game_ended:
		link.visible = false; 
		if Input.is_action_just_pressed("pause"):
			PauseMenu.get_node("MarginContainer").locked = false;
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn");

func _on_area_3d_body_entered(body):
	if body.is_in_group("Link"):
		link = body;
		start_ending();
