extends Node

var teams: Array[TeamData] = [TeamData.new(), TeamData.new()]
var sea_level: float = 0


func _ready():
	Debug.update_entry("wood", teams[0].resources[TeamData.resource_type.WOOD])


func on_resource_collected(resource_type: TeamData.resource_type, amount: int, team_id: int):
	teams[team_id].resources[resource_type] += amount
	Debug.update_entry("wood", teams[0].resources[resource_type])
