extends CharacterBody3D
class_name Player

const SPEED = 5.0
const ACCEL = 2.5
const SPRINT_FACTOR = 1.3
const WATER_SPEED_FACTOR = 0.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var team_id: int = 0
var is_in_water = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Debug.update_entry("is in water", is_in_water)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_in_water):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Handle sprint
	var target_speed = SPEED
	
	Debug.update_entry("depth", 0 - position.y + 0.5)
	if is_in_water:
		velocity.y += gravity * delta * (0 - global_position.y + 0.5)
		target_speed = SPEED * WATER_SPEED_FACTOR
		$Camera3D.fov = lerp($Camera3D.fov, 75.0, delta * 3)
		Debug.update_entry("state", "swimming")
	else:
		if Input.is_action_pressed("sprint"):
			target_speed = SPEED * SPRINT_FACTOR
			$Camera3D.fov = lerp($Camera3D.fov, 90.0, delta * 3)
			Debug.update_entry("state", "sprinting")
		else:
			$Camera3D.fov = lerp($Camera3D.fov, 75.0, delta * 3)
			Debug.update_entry("state", "walking")
	
	Debug.update_entry("speed", Vector2(velocity.x, velocity.z).length())
	
	velocity.x = move_toward(velocity.x, direction.x * target_speed, ACCEL)
	velocity.z = move_toward(velocity.z, direction.z * target_speed, ACCEL)
	
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			var look_dir = event.relative * 0.003
			rotation.y -= look_dir.x
			rotation.x = clamp(rotation.x - look_dir.y, -1.5, 1.5)
	if Input.is_action_just_pressed("collect"):
		try_collect()


func on_water_entered():
	$SFX/WaterSplash.play()
	is_in_water = true
	Debug.update_entry("is in water", is_in_water)

func on_water_exited():
	is_in_water = false
	Debug.update_entry("is in water", is_in_water)


func try_collect():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + -transform.basis.z * 2)
	var result = space_state.intersect_ray(query)
	if result.has("collider"):
		var target = result.collider.owner.get_parent()
		Debug.update_entry("target", target.is_in_group("palm_tree"))
		if target.is_in_group("tree"):
			target.on_collect(self)
	else:
		Debug.update_entry("target", "INVALID")


func on_wood_collected(amount: int = 1):
	Lobby.on_wood_collected(amount, team_id)
