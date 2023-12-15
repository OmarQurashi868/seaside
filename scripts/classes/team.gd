extends Node
class_name Team

var id: int = 0
var players: Array[Player] = []


func _init(team_id: int):
	id = team_id
