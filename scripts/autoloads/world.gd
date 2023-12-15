extends Node

var teams: Array[TeamData] = [TeamData.new(), TeamData.new()]
var sea_level: float = 0
var time = 0
@onready var water: MeshInstance3D = get_parent().get_node("Game/Water")
@onready var water_shader: ShaderMaterial = water.get_active_material(0)

 
func _ready():
	Debug.update_entry("wood", teams[0].resources[TeamData.resource_type.WOOD])


func _process(delta):
	time += delta

func on_resource_collected(resource_type: TeamData.resource_type, amount: int, team_id: int):
	teams[team_id].resources[resource_type] += amount
	Debug.update_entry("wood", teams[0].resources[resource_type])


func get_water_level(pos: Vector2) -> float:
	water_shader.set_shader_parameter("my_time", time)
	var uvx = (pos.x / water.mesh.get_aabb().size.x) - (water.mesh.get_aabb().size.x / 2)
	return sin(time + uvx) * 0.2;
	#var wave_speed = water_shader.get_shader_parameter("wave_speed")
	#var wave_size = water_shader.get_shader_parameter("wave_size")
	#var height = water_shader.get_shader_parameter("height")
	#var M_2PI = 6.283185307
	#var M_6PI = 18.84955592
	#var uvy = (pos.y / water.mesh.get_aabb().size.y) - (water.mesh.get_aabb().size.y / 2)
	#var my_time = time * wave_speed;
	#var uv = Vector2(uvx, uvy) * wave_size;
	#var d1 = fmod(uv.x + uv.y, M_2PI);
	#var d2 = fmod((uv.x + uv.y + 0.25) * 1.3, M_6PI);
	#d1 = my_time * 0.07 + d1;
	#d2 = my_time * 0.5 + d2;
	#var dist = Vector2(
		#sin(d1) * 0.15 + sin(d2) * 0.05,
		#cos(d1) * 0.15 + cos(d2) * 0.05
	#);
	#return dist.y * height;
