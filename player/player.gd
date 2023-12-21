extends CharacterBody3D
class_name Player

const SPEED = 5.0
const ACCEL = 2.5
const SPRINT_FACTOR = 1.3
const WATER_SPEED_FACTOR = 0.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var underwater_overlay: ShaderMaterial = $Camera3D/UnderwaterOverlay.get_active_material(0)
@onready var input: PlayerInput = $Input as PlayerInput
@onready var state_machine: StateMachine = $StateMachine as StateMachine
@onready var ui_controller: UIController = $UI as UIController
var seat: Seat
var boat: Boat

var team_id: int = 0
var is_in_water = false
var is_submergeed = false
var is_sprinting = false
var is_mounted = false
var in_menu = false
var building_boat: Boat

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Bus.boat_build_requested.connect(on_boat_build_requested)

func _physics_process(delta):
	state_machine.phys_proc(delta)
	
	handle_building()
	# Check if camera is submerged
	#World.get_water_level(Vector2(global_position.x, global_position.y))
	if $Camera3D.global_position.y < World.sea_level and not is_submergeed:
		on_submerged()
	if $Camera3D.global_position.y >= World.sea_level and is_submergeed:
		on_ascend()
	
	Debug.update_entry("depth", 0 - position.y + 0.5)
	Debug.update_entry("speed", Vector2(velocity.x, velocity.z).length())
	
	move_and_slide()

#region Handlers
func handle_gravity(delta):
	velocity.y -= gravity * delta

func handle_movement(delta, factor: float = 1.0, can_sprint: bool = true):
	if in_menu:
		velocity.x = 0.0
		velocity.z = 0.0
		return
	
	var input_dir = input.get_movement_vector()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if can_sprint and input.get_sprint():
		is_sprinting = true
		$Camera3D.fov = lerp($Camera3D.fov, 90.0, delta * 3)
	else:
		is_sprinting = false
		$Camera3D.fov = lerp($Camera3D.fov, 75.0, delta * 3)
	
	var target_speed = SPEED * factor * (SPRINT_FACTOR if is_sprinting else 1.0)
	velocity.x = move_toward(velocity.x, direction.x * target_speed, ACCEL)
	velocity.z = move_toward(velocity.z, direction.z * target_speed, ACCEL)

func handle_looking():
	var look_dir = input.get_mouse_vector() * 0.003
	rotation.y -= look_dir.x
	rotation.x = clamp(rotation.x - look_dir.y, -1.5, 1.5)

func handle_jumping():
	if in_menu:
		return
	
	if (is_on_floor() or is_in_water) and input.get_jump():
		velocity.y = JUMP_VELOCITY

func handle_shooting():
	pass

func handle_collecting():
	if input.get_collect():
		try_collect()

func handle_interaction():
	if is_mounted:
		if input.get_interact():
			on_eject()
		return
	
	var target = shoot_ray()
	if target.has("collider"):
		target = target.collider
	# TODO: Update UI indicator
	
	if input.get_interact():
		if target is DriverSeat:
			target.mount(self)
			on_mount(target)

func handle_build_menu():
	if input.get_build_menu() and not building_boat:
		in_menu = ui_controller.toggle_menu("Building")

func handle_building():
	if not building_boat:
		return
	
	var target = shoot_ray(10, 0x8)
	if target.has("position"):
		building_boat.global_position = target.position
		if target.collider.is_in_group("water"):
			if input.get_shoot():
				building_boat.get_node("CollisionShape3D").disabled = false
				on_resource_spent(TeamData.resource_type.WOOD, building_boat.cost)
				building_boat = null
				ui_controller.update_buttons()
	else:
		building_boat.global_position = Vector3(0, -1000, 0)
	
	if input.get_collect():
		building_boat.queue_free()
		building_boat = null
#endregion


func on_water_entered():
	is_in_water = true
func on_water_exited():
	is_in_water = false

func on_submerged():
	is_submergeed = true
	Bus.player_entered_water.emit()
	#underwater_overlay.set_shader_parameter("target_alpha", 0.5)
	var tween = get_tree().create_tween()
	tween.tween_property(underwater_overlay, "shader_parameter/target_alpha", 0.5, 0.1)
func on_ascend():
	is_submergeed = false
	Bus.player_exited_water.emit()
	var tween = get_tree().create_tween()
	tween.tween_property(underwater_overlay, "shader_parameter/target_alpha", 0.0, 0.1)

func on_mount(req_seat: Seat):
	is_mounted = true
	seat = req_seat
	boat = seat.get_parent() as Boat
	global_position = seat.global_position
	velocity = Vector3.ZERO
	state_machine.change_state("Mounted")
	Debug.update_entry("mounted", is_mounted)
func on_eject():
	is_mounted = false
	seat.eject()
	seat = null
	state_machine.change_state("Land")
	Debug.update_entry("mounted", is_mounted)

func on_resource_collected(resource_type: TeamData.resource_type, amount: int = 1):
	World.on_resource_collected(resource_type ,amount, team_id)
	ui_controller.update_buttons()

func on_resource_spent(resource_type: TeamData.resource_type, amount: int = 1) -> bool:
	return World.on_resource_spent(resource_type ,amount, team_id)

func can_afford(resource_type: TeamData.resource_type, amount: int = 1) -> bool:
	return World.can_afford(resource_type, amount, team_id)


func on_boat_build_requested(player: Player, boat_data):
	if player != self:
		return
	
	if not can_afford(TeamData.resource_type.WOOD, boat_data["cost"]):
		return
	
	in_menu = ui_controller.toggle_menu("Building")
	
	var boat_scene_path = boat_data["path"]
	building_boat = load(boat_scene_path).instantiate()
	building_boat.cost = boat_data["cost"]
	building_boat.get_node("CollisionShape3D").disabled = true
	get_parent().add_child(building_boat)
	building_boat.global_position = Vector3(0, -1000, 0)

func try_collect():
	var target = shoot_ray()
	if target.has("collider"):
		target = target.collider
	if target:
		Debug.update_entry("target", target.name)
		if target.is_in_group("resource"):
			target.on_collect(self)
	else:
		Debug.update_entry("target", "")

func shoot_ray(length: float = 2, col_mask: int = 0xFFFFFFFF):
	var space_state = get_world_3d().direct_space_state
	var origin = $Camera3D.global_position
	var target = $Camera3D.global_position + -transform.basis.z * length
	var query = PhysicsRayQueryParameters3D.create(origin, target)
	query.collide_with_areas = true
	query.collision_mask = col_mask
	var result = space_state.intersect_ray(query)
	if result.has("position"):
		Bus.debug_raycast_requested.emit(result.position)
	return result
