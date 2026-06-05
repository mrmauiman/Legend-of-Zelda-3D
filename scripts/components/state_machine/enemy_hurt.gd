class_name EnemyHurtState extends State

@export var is_weak_enemy: bool = false;
@export var spawn_iframes: float = 0;
@export var can_split: bool = false;
@export var static_states: Array[String] = [];
@export var arrow_weakness: bool = false;
@export var magic_immune: bool = false;

var stun_timer: float = 0;
var iframe_timer: float = 0;

func _ready():
	iframe_timer = spawn_iframes;

func _process(delta):
	if iframe_timer > 0:
		iframe_timer -= delta;

func enter(_previous_state: State,  _params: Array):
	character.play_hurt_animation();
	character.animation_player.animation_finished.connect(_animation_finished);

func exit(_new_state: State):
	character.animation_player.animation_finished.disconnect(_animation_finished);

func update(_delta):
	pass

func physics_update(_delta):
	pass;

func change_state():
	character.velocity = Vector3.ZERO;
	if stun_timer > 0:
		state_machine.change_state("Stunned", stun_timer);
	else:
		state_machine.change_state("Patrol");

func _animation_finished(_anim: String):
	change_state();

func darknut_blocked(knockback: Vector3) -> bool:
	if not character is Darknut: return false;
	var character_alignment = -character.transform.basis.z.normalized();
	character_alignment.y = 0;
	return character_alignment.angle_to(knockback.normalized()) < deg_to_rad(45);

func _on_hurt_box_area_entered(area):
	if area is HitBox and state_machine.state.name != "Hurt" and iframe_timer <= 0:
		var hitbox: HitBox = area;
		if magic_immune and hitbox.is_magic: return;
		var knockback = hitbox.knockback;
		var attack_dir = Vector3.FORWARD;
		if hitbox.relative_knockback_orientor and hitbox.xz_omni_dir_knockback:
			var xz_speed = Vector2(hitbox.knockback.x, hitbox.knockback.z).length();
			var dir = (global_position - hitbox.relative_knockback_orientor.global_position);
			dir.y = 0;
			attack_dir = dir;
			var xz_knockback = xz_speed * dir.normalized();
			knockback = Vector3(xz_knockback.x, hitbox.knockback.y, xz_knockback.z);
		elif hitbox.relative_knockback_orientor:
			var orientor_forward = -hitbox.relative_knockback_orientor.global_transform.basis.z;
			attack_dir = orientor_forward;
			if hitbox.is_sword and not hitbox.is_sword_beam: attack_dir *= -1;
			var orientor_right = hitbox.relative_knockback_orientor.global_transform.basis.x;
			knockback = (orientor_forward * knockback.z) + (orientor_right * knockback.x) + (Vector3.UP * knockback.y);
		if not hitbox.darknut_cant_block and darknut_blocked(attack_dir): 
			SoundSystem.play("res://audio/sfx/Blocked.wav", global_position);
			hitbox.hit.emit(self);
			return;
		if not state_machine.get_current_state() in static_states:
			state_machine.change_state("Hurt");
			character.velocity = knockback;
			stun_timer = hitbox.stun_time;
		else:
			if hitbox.stun_time > 0:
				state_machine.change_state("Stunned", hitbox.stun_time);
			character.color_animation_player.play("hurt");
		if hitbox.is_arrow and arrow_weakness:
			character.health.take_damage(character.health.max_health);
		else:
			character.health.take_damage(hitbox.get_damage(is_weak_enemy));
		hitbox.hit.emit(self);
		var damage = hitbox.get_damage(is_weak_enemy)
		if can_split and damage < character.health.max_health and damage > 0:
			character.split();
		elif character.health.is_dead():
			character.die();
		else:
			SoundSystem.play("res://audio/sfx/EnemyHurt.wav", global_position);
