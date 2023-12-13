extends Node

var teams: Array[Team] = [Team.new(0)]


func _ready():
	Debug.update_entry("wood", teams[0].resources.wood)


func on_wood_collected(amount: int, team_id: int):
	teams[team_id].resources.wood += amount
	Debug.update_entry("wood", teams[0].resources.wood)
