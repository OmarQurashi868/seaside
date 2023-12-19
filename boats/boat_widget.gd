extends PanelContainer

var player: Player
var boat_id: int


func _on_button_button_up():
	Bus.boat_build_requested.emit(player, boat_id)
