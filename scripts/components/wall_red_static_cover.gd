extends StaticBody3D

func destroy():
	SoundSystem.play_global("res://audio/sfx/SecretUncovered.wav");
	queue_free();
