extends State

func on_enter():
	Debug.update_entry("state", "walking")

func phys_proc(delta) -> String:
	player.handle_gravity(delta)
	player.handle_movement(delta)
	if player.is_sprinting:
		Debug.update_entry("state", "sprinting")
	else:
		Debug.update_entry("state", "walking")
	player.handle_looking()
	player.handle_jumping()
	player.handle_shooting()
	player.handle_collecting()
	player.handle_interaction()
	if player.is_in_water:
		return "Sea"
	return ""
