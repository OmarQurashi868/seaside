extends Area3D

#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var floaters = []


func _physics_process(delta):
	for floater in floaters:
		floater.velocity.y += gravity * delta * (0 - floater.position.y + 0.5)


func _on_body_entered(body):
	if body.is_in_group("players"):
		body = body as Player
		body.on_water_entered()
		floaters.append(body)


func _on_body_exited(body):
	if body.is_in_group("players"):
		body = body as Player
		body.on_water_exited()
		floaters.erase(body)
