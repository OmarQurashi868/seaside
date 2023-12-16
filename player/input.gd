extends Node
class_name PlayerInput

var mouse_relative: Vector2 = Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	mouse_relative = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_relative = event.relative


func get_movement_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

func get_mouse_vector() -> Vector2:
	return mouse_relative

func get_sprint() -> bool:
	return Input.is_action_pressed("sprint")

func get_jump() -> bool:
	return Input.is_action_just_pressed("jump")

func get_shoot() -> bool:
	return Input.is_action_just_pressed("shoot")

func get_collect() -> bool:
	return Input.is_action_just_pressed("collect")

func get_interact() -> bool:
	return Input.is_action_just_pressed("interact")
