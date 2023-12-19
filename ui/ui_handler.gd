extends Control
class_name UIController

@onready var boat_list: BoatListResource = preload("res://boats/boat_list_resource.tres")
@onready var boat_list_container: GridContainer = $"Menues/Building/ScrollContainer/GridContainer"
@onready var boat_grid_item = preload("res://boats/boat_widget.tscn")
@onready var player: Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	Bus.boat_build_requested.connect(on_boat_build_requested)
	generate_boat_building_list()

func generate_boat_building_list():
	var all_boats = boat_list.boats
	for boat in all_boats:
		var new_grid_item = boat_grid_item.instantiate()
		
		new_grid_item.player = get_parent()
		new_grid_item.boat_id = boat.id
		
		new_grid_item.name = boat.name
		new_grid_item.get_node("VBoxContainer/CostLabel").text = "COST: " + str(boat.cost)
		new_grid_item.get_node("VBoxContainer/NameLabel").text = boat.name
		var tex_rect = new_grid_item.get_node("VBoxContainer/TextureRect") as TextureRect
		tex_rect.texture.resource_path = boat.img_path
		
		boat_list_container.add_child(new_grid_item)

func toggle_menu(name: String) -> bool:
	var menu = get_node("Menues/" + name)
	menu.visible = !menu.visible
	$Reticle.visible = !menu.visible
	return menu.visible


func on_boat_build_requested(player: Player, boat_id: int):
	pass
