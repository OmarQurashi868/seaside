extends Resource
class_name BoatListResource

class BoatListData:
	var id: int
	var name: String
	var cost: int
	var path: String
	var img_path: String
	func _init(id, name, cost, path, img_path):
		self.id = id
		self.name = name
		self.cost = cost
		self.path = path
		self.img_path = img_path

var boats: Array[BoatListData] = [
	BoatListData.new(0, "Simple Boat", 30, "res://boats/boat_list/simple_boat.tscn", "res://boats/boat_list/simple_boat_img.png"),
]
