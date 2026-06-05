extends MarginContainer

@export var play_position = Vector2(0, -1080);
@export var pause_position = Vector2(0, 0);

@export var move_speed = 1080*2;

var paused = false;
var goal_position = play_position;
var has_context = false;
var saving = false;
var locked = false;

func _ready():
	play_position.y = -get_viewport().get_visible_rect().size.y;
	position = play_position;

func _process(delta):
	if get_tree().current_scene is CanvasLayer: return;
	play_position.y = -get_viewport().get_visible_rect().size.y;
	if goal_position != play_position and goal_position != pause_position:
		goal_position = play_position;
	if Input.is_action_just_pressed("pause") and not saving and not locked:
		paused = not paused;
		has_context = true;
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			get_tree().paused = true;
			has_context = false;
			goal_position = pause_position;
			if get_viewport().gui_get_focus_owner() == null:
				%GridContainer.get_child(0).grab_focus();
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
			goal_position = play_position;
	
	if position != goal_position:
		var mul = 1 if paused else -1;
		position.y = clamp(position.y + (mul * move_speed * delta), play_position.y, 0);
	elif not paused and get_tree().paused and has_context:
		get_tree().paused = false;
		has_context = false;

func show_saving_popup():
	get_parent().get_node("SavingPopup").visible = true;
	saving = true;

func show_saved_popup():
	get_parent().get_node("SavingPopup").visible = false;
	get_parent().get_node("SavedPopup").visible = true;
	get_parent().get_node("SavedPopup/GameOver").visible = Inventory.health <= 0;
	get_parent().get_node("SavedPopup/Continue").grab_focus();

const LEVELS: Dictionary = {
	Inventory.LEVELS.OVERWORLD: "res://scenes/chunked_worlds/overworld/overworld.tscn",
	Inventory.LEVELS.ONE: "res://scenes/environment/dungeons/level_1.tscn",
	Inventory.LEVELS.TWO: "res://scenes/environment/dungeons/level_2.tscn",
	Inventory.LEVELS.THREE: "res://scenes/environment/dungeons/level_3.tscn",
	Inventory.LEVELS.FOUR: "res://scenes/environment/dungeons/level_4.tscn",
	Inventory.LEVELS.FIVE: "res://scenes/environment/dungeons/level_5.tscn",
	Inventory.LEVELS.SIX: "res://scenes/environment/dungeons/level_6.tscn",
	Inventory.LEVELS.SEVEN: "res://scenes/environment/dungeons/level_7.tscn",
	Inventory.LEVELS.EIGHT: "res://scenes/environment/dungeons/level_8.tscn",
	Inventory.LEVELS.NINE: "res://scenes/environment/dungeons/level_9.tscn"
};
func _on_continue_pressed():
	saving = false;
	get_parent().get_node("SavedPopup").visible = false;
	%SaveButton.grab_focus();
	if Inventory.health <= 0:
		Inventory.load_data(Inventory.current_slot);
		EnemyTracker.load_data(Inventory.current_slot);
		get_tree().change_scene_to_file(LEVELS[Inventory.current_level]);

func _on_quit_pressed():
	saving = false;
	get_parent().get_node("SavedPopup").visible = false;
	%SaveButton.grab_focus();
	paused = false;
	get_tree().paused = false;
	has_context = false;
	goal_position = play_position;
	position = play_position;
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn");


func _on_save_button_pressed():
	show_saving_popup();
	call_deferred("save_data");

func save_data():
	Inventory.save_data(Inventory.current_slot);
	EnemyTracker.save_data(Inventory.current_slot);
	show_saved_popup();
