extends Control

@onready var debug_entry_scene = preload("res://scenes/debug_entry.tscn")


func update_entry(entry: String, value) -> void:
	var entries = $Panel/Container.get_children()
	for e in entries:
		if entry == e.name:
			e.get_node("Key").text = entry + ":"
			e.get_node("Value").text = str(value)
			return
	var new_entry = debug_entry_scene.instantiate()
	new_entry.name = entry
	new_entry.get_node("Key").text = entry + ":"
	new_entry.get_node("Value").text = str(value)
	$Panel/Container.add_child(new_entry)
