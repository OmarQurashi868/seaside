extends Node
class_name StateMachine

@onready var current_state: State = get_node("Land")
var player: Player

func _enter_tree():
	player = get_parent() as Player

func _ready():
	current_state.on_enter()

func phys_proc(delta):
	var new_state = current_state.phys_proc(delta)
	if new_state:
		change_state(new_state)

func change_state(new_state: String):
	current_state.on_exit()
	current_state = get_node(new_state) as State
	current_state.on_enter()
