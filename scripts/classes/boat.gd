extends RigidBody3D
class_name Boat

@export var speed: float = 5.0
@export var steering: float = 2.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_in_water = false
var time = 0

@onready var mesh = $Plane as MeshInstance3D
@onready var offset = mesh.get_aabb().size.y / 2


func _physics_process(delta):
	time += delta
	rotation.x = sin(time) * 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	var depth = World.sea_level - global_position.y + offset/2
	if is_in_water:
		apply_force(Vector3.UP * (gravity + gravity * depth))


func on_water_entered():
	$SFX/WaterSplash.play()
	is_in_water = true
	Debug.update_entry("boat in water", is_in_water)

func on_water_exited():
	is_in_water = false
	Debug.update_entry("boat in water", is_in_water)
