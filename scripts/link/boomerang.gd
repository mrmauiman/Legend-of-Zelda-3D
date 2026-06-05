extends CharacterBody3D

@export var direction: Vector3;
@export var link: CharacterBody3D;

@export var speed: float = 9.6;
@export var spin_speed: float = 360*4;

const RETURN_MAX_TIME: float = 4;

var returning = false;

var timer: float = 0;
var boomerang_model;
var sfx: AudioStreamPlayer3D;

func start_returning():
	returning = true;
	timer = 0;
	%CollisionShape3D.disabled = true;

func _ready():
	if not direction or not link:
		print("Either Target or Link were not set.  Destroying self");
		queue_free();
	
	if Inventory.items.boomerang == Inventory.ITEM_TYPES.NONE:
		queue_free();
	else:
		sfx = SoundSystem.play("res://audio/sfx/Boomerang.wav", global_position);

	if Inventory.items.boomerang == Inventory.ITEM_TYPES.LVL1:
		%BoomerangModel.visible = true;
		%MagicBoomerangModel.visible = false;
		boomerang_model = %BoomerangModel;
	elif Inventory.items.boomerang == Inventory.ITEM_TYPES.LVL2:
		speed *= 2;
		spin_speed *= 2;
		%HitBox.stun_time *= 2;
		%BoomerangModel.visible = false;
		%MagicBoomerangModel.visible = true;
		boomerang_model = %MagicBoomerangModel;

func _exit_tree():
	if link: link.boomerang_thrown = false;
	if sfx: sfx.stop();

func _physics_process(delta):
	if sfx: sfx.global_position = global_position;
	boomerang_model.rotation.x += deg_to_rad(spin_speed * delta);
	if returning:
		timer += delta;
		if not link or timer >= RETURN_MAX_TIME:
			if link: link.boomerang_thrown = false;
			if sfx: sfx.stop();
			queue_free();
			return;
		var link_pos = link.global_position + (Vector3.UP * 0.8)
		look_at(link_pos);
		velocity = global_position.direction_to(link_pos) * speed;
		move_and_slide();
		if global_position.distance_to(link_pos) < 0.8: 
			link.boomerang_thrown = false;
			if sfx: sfx.stop();
			queue_free();
	else:
		timer += delta;
		if timer >= 1:
			start_returning();
		
		if %RayCast3D.is_colliding():
			var collision_point = %RayCast3D.get_collision_point();
			position = collision_point + (Vector3.UP * 0.8);
		
		look_at(global_position + direction);
		
		velocity = direction.normalized() * speed;
		var collision: KinematicCollision3D = move_and_collide(velocity * delta);
		if collision:
			start_returning();


func _on_hit_box_area_entered(area):
	if not area is HitBox:
		start_returning();
