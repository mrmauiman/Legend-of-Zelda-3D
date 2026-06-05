extends Area3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;

var link = null;

func _animation_finished(anim):
	if anim == "reveal":
		play_heal_sound();
		animation_player.play("spin");
	elif anim == "hide":
		heal_finished();

func heal():
	animation_player.play("reveal");
	link.state = link.STATES.FAIRY_HEALING;
	link.velocity = Vector3.ZERO;

func heal_finished():
	link.state = link.STATES.MOVE;

var heal_sfx: AudioStreamPlayer;

func play_heal_sound():
	heal_sfx = SoundSystem.play_global("res://audio/sfx/RupeeDecreaseLoop.ogg");
	heal_sfx.volume_linear *= 0.5;

func _on_body_entered(body):
	if body.is_in_group("Link"):
		link = body;
		var dir = link.global_position - global_position;
		dir = Vector2(dir.x, dir.z).normalized();
		var angle = -Vector2.DOWN.angle_to(dir);
		%HealingEffect.rotation.y = angle;
		# if %HealingEffect/Spin.is_playing():
		# 	%HealingEffect/Spin.stop();
		# %HealingEffect/Spin.play("spin");
		heal();

func check_healed():
	Inventory.heal(0.5);
	if Inventory.health >= Inventory.get_max_health():
		animation_player.play("hide");
		heal_sfx.stop();
		var ending_sfx = SoundSystem.play_global("res://audio/sfx/RupeeDecreaseEnding.ogg");
		ending_sfx.volume_linear *= 0.5;
