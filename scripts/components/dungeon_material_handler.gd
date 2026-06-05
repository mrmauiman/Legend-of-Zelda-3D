class_name DungeonMesh extends MeshInstance3D

const MATERIAL = preload("res://materials/dungeon_material.tres");
const BLACK_OUT_MATERIAL = preload("res://materials/black_out.tres");
const DUNGEON_COLORS := {
	Inventory.LEVELS.ONE: {
		"accent_color": Color("#2038ec"),
		"highlight_color": Color("#00e8d8"),
		"base_color": Color("#008088"),
		"shadow_color": Color("#183c5c")
	},
	Inventory.LEVELS.TWO: {
		"accent_color": Color("#d82800"),
		"highlight_color": Color("#5c94fc"),
		"base_color": Color("#2038ec"),
		"shadow_color": Color("#0000a8")
	},
	Inventory.LEVELS.THREE: {
		"accent_color": Color("#d82800"),
		"highlight_color": Color("#58f898"),
		"base_color": Color("#008f38"),
		"shadow_color": Color("#003c14")
	},
	Inventory.LEVELS.FOUR: {
		"accent_color": Color("#2038ec"),
		"highlight_color": Color("#f0bc3c"),
		"base_color": Color("#887000"),
		"shadow_color": Color("#402c00")
	},
	Inventory.LEVELS.FIVE: {
		"accent_color": Color("#d82800"),
		"highlight_color": Color("#4cdc48"),
		"base_color": Color("#00a800"),
		"shadow_color": Color("#005000")
	},
	Inventory.LEVELS.SIX: {
		"accent_color": Color("#d82800"),
		"highlight_color": Color("#f0bc3c"),
		"base_color": Color("#887000"),
		"shadow_color": Color("#402c00")
	},
	Inventory.LEVELS.SEVEN: {
		"accent_color": Color("#2038ec"),
		"highlight_color": Color("#4cdc48"),
		"base_color": Color("#00a800"),
		"shadow_color": Color("#005000")
	},
	Inventory.LEVELS.EIGHT: {
		"accent_color": Color("#5c94fc"),
		"highlight_color": Color("#fcfcfc"),
		"base_color": Color("#bcbcbc"),
		"shadow_color": Color("#747474")
	},
	Inventory.LEVELS.NINE: {
		"accent_color": Color("#d82800"),
		"highlight_color": Color("#fcfcfc"),
		"base_color": Color("#bcbcbc"),
		"shadow_color": Color("#747474")
	}
};

var mat: ShaderMaterial;

var lit = true;

func update_material():
	var base_material: StandardMaterial3D = mesh.surface_get_material(0);
	var texture_path = base_material.albedo_texture.resource_path;
	
	mat = MATERIAL.duplicate(true);
	mat.set_shader_parameter("image", load(texture_path));
	var colors = DUNGEON_COLORS[Inventory.current_level];
	for color in colors:
		mat.set_shader_parameter(color, colors[color]);
	
	if lit:
		set_surface_override_material(0, mat);

func _ready():
	call_deferred("update_material");

func black_out():
	set_surface_override_material(0, BLACK_OUT_MATERIAL);
	lit = false;

func light_up():
	set_surface_override_material(0, mat);
	lit = true;
