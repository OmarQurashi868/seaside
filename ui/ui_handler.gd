extends Control
class_name UIController

@onready var boat_list: BoatListResource = preload("res://boats/boat_list_resource.tres")
@onready var boat_list_container: GridContainer = $"Menues/Building/ScrollContainer/GridContainer"
@onready var boat_grid_item = preload("res://boats/boat_widget.tscn")
@onready var player: Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_boat_building_list()

func generate_boat_building_list():
	var all_boats = boat_list.boats
	for i in all_boats.size():
		var new_grid_item = boat_grid_item.instantiate()
		
		new_grid_item.player = get_parent()
		new_grid_item.boat_data = all_boats[i]
		
		new_grid_item.get_node("VBoxContainer/CostLabel").text = "COST: " + str(all_boats[i]["cost"])
		new_grid_item.get_node("VBoxContainer/NameLabel").text = all_boats[i]["name"]
		var can_afford = player.can_afford(TeamData.resource_type.WOOD, all_boats[i]["cost"])
		new_grid_item.get_node("VBoxContainer/Button").disabled = !can_afford
		var tex_rect = new_grid_item.get_node("VBoxContainer/TextureRect") as TextureRect
		tex_rect.texture.resource_path = all_boats[i]["img_path"]
		
		boat_list_container.add_child(new_grid_item)

func update_buttons():
	var widgets = $Menues/Building/ScrollContainer/GridContainer.get_children()
	for widget in widgets:
		var can_afford = player.can_afford(TeamData.resource_type.WOOD, widget.boat_data["cost"])
		widget.get_node("VBoxContainer/Button").disabled = !can_afford

func toggle_menu(menu_name: String) -> bool:
	var menu = get_node("Menues/" + menu_name)
	menu.visible = !menu.visible
	$Reticle.visible = !menu.visible
	if menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	return menu.visible
