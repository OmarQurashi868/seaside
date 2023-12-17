extends Node3D
class_name Seat

func mount(player: Player):
	$RemoteTransform3D.remote_path = player.get_path()

func eject():
	$RemoteTransform3D.remote_path = ""
