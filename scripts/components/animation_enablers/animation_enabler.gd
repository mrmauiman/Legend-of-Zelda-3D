@abstract
class_name AnimationEnabler extends Node

@export var animation_player: AnimationPlayer;
@export var animation_sections: Array[AnimationSection] = [];

var enabled = false;

@abstract
func enable();

@abstract
func disable();

func _ready():
	disable();

func _process(_delta):
	var anim = animation_player.current_animation;
	if anim:
		for anim_section in animation_sections:
			var anim_pos = animation_player.current_animation_position;
			if anim == anim_section.animation and anim_section.start_time <= anim_pos and anim_section.end_time > anim_pos:
				if not enabled:
					enable();
					enabled = true;
				return;
	if enabled:
		enabled = false;
		disable();
