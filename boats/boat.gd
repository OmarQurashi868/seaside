extends RigidBody3D
class_name Boat

@export var speed: float = 10.0
@export var steering: float = 7.5
@export var health: float = 10.0
@export var seats: Array[Seat]

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_in_water = false
var time = 0
var force: float = 0.0
var torque: float = 0.0
var cost: int

@onready var mesh = $Plane as MeshInstance3D
@onready var offset = mesh.get_aabb().size.y / 2


func _physics_process(delta):
	time += delta
	rotation.x = sin(time) * 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(_state):
	var depth = World.sea_level - global_position.y + offset/2
	if is_in_water:
		apply_force(Vector3.UP * (gravity + gravity * depth) * mass)
		apply_force(transform.basis.z * force * speed * 200)
		apply_torque(Vector3(0, -torque * steering, 0) * 200)
		force = 0.0
		torque = 0.0


func on_water_entered():
	$SFX/WaterSplash.play()
	is_in_water = true
	Debug.update_entry("boat in water", is_in_water)

func on_water_exited():
	is_in_water = false
	Debug.update_entry("boat in water", is_in_water)
