extends State

func on_enter():
	player.get_node("SFX/WaterSplash").play()
	Debug.update_entry("state", "swimming")

func phys_proc(delta) -> String:
	player.handle_gravity(delta)
	player.velocity.y += player.gravity * delta * (0 - player.global_position.y + 0.5)
	player.handle_movement(delta, player.WATER_SPEED_FACTOR, false)
	player.handle_looking()
	player.handle_jumping()
	player.handle_shooting()
	player.handle_collecting()
	player.handle_interaction()
	if not player.is_in_water:
		return "Land"
	return ""
