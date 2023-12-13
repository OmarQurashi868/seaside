extends Node3D
class_name Boat

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var mass: float = 10.0
@export var body: RigidBody3D
var is_in_water = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body.lock_rotation = true
	body.mass = mass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_in_water:
		body.apply_force(Vector3(0, 10*delta, 0))


func on_water_entered():
	$SFX/WaterSplash.play()
	is_in_water = true
	Debug.update_entry("boat in water", is_in_water)

func on_water_exited():
	is_in_water = false
	Debug.update_entry("boat in water", is_in_water)
