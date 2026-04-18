extends Node

# to locate previous room for inventory
var previous_room = ""
var inventory_room_path: String = "res://rooms/inventory.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#call inventory from any way
func open_inventory(current_room_path: String) -> void:
	previous_room = current_room_path
	get_tree().change_scene_to_file(inventory_room_path)

#Time

#calendar
#inventory JSON system
#player status global/local
#level system for unlocking new equipment and seeds
