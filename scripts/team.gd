extends Node
class_name Team

var id: int = 0
var players: Array[Player] = []
var resources: Resources = Resources.new()

class Resources:
	var wood: int = 0

func _init(team_id: int):
	id = team_id
