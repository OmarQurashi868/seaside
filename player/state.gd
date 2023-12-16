extends Node
class_name State

var state_machine: StateMachine
var player: Player

func _ready():
	state_machine = get_parent() as StateMachine
	player = state_machine.player as Player

func on_enter():
	pass

func on_exit():
	pass

func phys_proc(_delta) -> String:
	return ""
