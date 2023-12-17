extends State

func on_enter():
	Debug.update_entry("state", "mounted")

func phys_proc(_delta) -> String:
	player.handle_looking()
	player.handle_shooting()
	player.handle_interaction()
	var input_vector = player.input.get_movement_vector()
	player.boat.force = input_vector.y
	player.boat.torque = input_vector.x
	return ""
