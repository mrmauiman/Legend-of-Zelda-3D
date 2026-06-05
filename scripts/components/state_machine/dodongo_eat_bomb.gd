extends State

var bomb;

func animation_finished(anim):
	if anim == "eat_bomb":
		character.animation_player.play("stunned");
		character.color_animation_player.play("hurt");
		character.health.take_damage(ceili(character.health.max_health/2.0));
		if character.health.is_dead():
			character.die();
			return;
	if anim == "stunned":
		state_machine.change_state("Default");

func enter(_previous_state: State, params: Array):
	character.animation_player.play("eat_bomb");
	bomb = params[0];
	character.animation_player.animation_finished.connect(animation_finished);

func exit(_new_state: State):
	character.animation_player.animation_finished.disconnect(animation_finished);

func update(_delta):
	if character.animation_player.current_animation_position >= 0.2 and bomb:
		bomb.queue_free();

func physics_update(_delta):
	character.velocity.x = 0;
	character.velocity.z = 0;


func _on_bomb_detector_body_entered(body):
	if body is Bomb:
		state_machine.change_state("EatBomb", body);
