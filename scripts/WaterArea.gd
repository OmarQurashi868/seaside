extends Area3D


func _on_body_entered(body):
	if body.has_method("on_water_entered"):
		body.on_water_entered()
	if body.owner.get_parent().has_method("on_water_entered"):
		body.owner.get_parent().on_water_entered()


func _on_body_exited(body):
	if body.has_method("on_water_exited"):
		body.on_water_exited()
	if body.owner.get_parent().has_method("on_water_exited"):
		body.owner.get_parent().on_water_exited()
