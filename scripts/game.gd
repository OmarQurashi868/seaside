extends Node3D

func _process(_delta):
	Debug.update_entry("FPS", Engine.get_frames_per_second())
