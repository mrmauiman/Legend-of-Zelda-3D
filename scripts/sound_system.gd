extends Node3D

@onready var intro_music = %IntroMusic;
@onready var overworld_music = %OverWorldMusic;
@onready var level_music = {
	Inventory.LEVELS.ONE: %Level1Music,
	Inventory.LEVELS.TWO: %Level2Music,
	Inventory.LEVELS.THREE: %Level3Music,
	Inventory.LEVELS.FOUR: %Level4Music,
	Inventory.LEVELS.FIVE: %Level5Music,
	Inventory.LEVELS.SIX: %Level6Music,
	Inventory.LEVELS.SEVEN: %Level7Music,
	Inventory.LEVELS.EIGHT: %Level8Music,
	Inventory.LEVELS.NINE: %Level9Music,
};
@onready var triforce_music = %TriforceMusic;
@onready var game_over_music = %GameOver;
@onready var global_SFXs = [%SFXGlobal1, %SFXGlobal2, %SFXGlobal3, %SFXGlobal4, %SFXGlobal5, %SFXGlobal6, %SFXGlobal7, %SFXGlobal8];
@onready var SFXs = [%SFX1, %SFX2, %SFX3, %SFX4, %SFX5, %SFX6, %SFX7, %SFX8, %SFX9, %SFX10, %SFX11, %SFX12, %SFX13, %SFX14, %SFX15, %SFX16];

func _ready():
	play_overworld_music();

func sound_track_changed():
	for level in level_music:
		if level_music[level].playing:
			play_dungeon_music();
			return;

func update_music_volume():
	if intro_music: intro_music.volume_linear = Settings.music_volume;
	if overworld_music: overworld_music.volume_linear = Settings.music_volume;
	if triforce_music: triforce_music.volume_linear = Settings.music_volume;
	if game_over_music: game_over_music.volume_linear = Settings.music_volume;
	if level_music:
		for level in level_music:
			level_music[level].volume_linear = Settings.music_volume;

func stop_music():
	intro_music.stop();
	overworld_music.stop();
	triforce_music.stop();
	game_over_music.stop();
	for level in level_music:
			level_music[level].stop();

func play_intro_music():
	stop_music();
	intro_music.volume_linear = Settings.music_volume;
	intro_music.play();

func play_overworld_music():
	stop_music();
	overworld_music.volume_linear = Settings.music_volume;
	overworld_music.play();

func play_dungeon_music():
	stop_music();
	if Settings.sound_track == Settings.SOUND_TRACK.ORIGINAL:
		if Inventory.current_level == Inventory.LEVELS.NINE:
			level_music[Inventory.LEVELS.NINE].volume_linear = Settings.music_volume;
			level_music[Inventory.LEVELS.NINE].play();
		else:
			level_music[Inventory.LEVELS.ONE].volume_linear = Settings.music_volume;
			level_music[Inventory.LEVELS.ONE].play();
		return;
	
	level_music[Inventory.current_level].volume_linear = Settings.music_volume;
	level_music[Inventory.current_level].play();


func play_triforce_music():
	stop_music();
	triforce_music.volume_linear = Settings.music_volume;
	triforce_music.play();

func play_game_over_music():
	stop_music();
	game_over_music.volume_linear = Settings.music_volume;
	game_over_music.play();

func get_free_channel(channels) -> int:
	var i = 0;
	for sfx in channels:
		if not sfx.playing:
			return i;
		i+=1;
	return -1;


## If loop is enabled it is the callers responsibility to stop it when ready.
func play(sfx_path: String, playback_position: Vector3) -> AudioStreamPlayer3D:
	var sfx: AudioStream = load(sfx_path);
	var player_id = get_free_channel(SFXs);
	if player_id == -1:
		return null;
	var player = SFXs[player_id];
	player.stream = sfx;
	player.global_position = playback_position;
	player.volume_linear = Settings.sfx_volume;
	player.play();
	return player;

## If loop is enabled it is the callers responsibility to stop it when ready.
func play_global(sfx_path: String) -> AudioStreamPlayer:
	var sfx: AudioStream = load(sfx_path);
	var player_id = get_free_channel(global_SFXs);
	if player_id == -1:
		return null;
	var player = global_SFXs[player_id];
	player.stream = sfx;
	player.volume_linear = Settings.sfx_volume;
	player.play();
	return player;
