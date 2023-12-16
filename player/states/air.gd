extends State

func on_enter():
	Debug.update_entry("state", "midair")

func phys_proc(delta) -> String:
	player.handle_gravity(delta)
	player.handle_movement(delta)
	player.handle_looking()
	player.handle_jumping()
	player.handle_shooting()
	player.handle_collecting()
	player.handle_interaction()
	return ""
