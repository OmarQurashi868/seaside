extends Node3D


func _ready():
	Bus.player_entered_water.connect(on_player_entered_water)
	Bus.player_exited_water.connect(on_player_exited_water)
	Bus.debug_raycast_requested.connect(debug_raycast)
	


func _process(_delta):
	Debug.update_entry("FPS", Engine.get_frames_per_second())


func on_player_entered_water():
	var tween = get_tree().create_tween()
	tween.tween_property($Ambience/Ambience, "pitch_scale", 0.5, 0.2)
	#$Ambience/Ambience.pitch_scale = 0.5

func on_player_exited_water():
	var tween = get_tree().create_tween()
	tween.tween_property($Ambience/Ambience, "pitch_scale", 1.0, 0.2)
	#$Ambience/Ambience.pitch_scale = 1.0

func debug_raycast(pos: Vector3):
	$Pointer.global_position = pos
	print('hi')
