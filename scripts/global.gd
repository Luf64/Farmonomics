extends Node

# to locate previous room for inventory
var inventory_ui = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory_room = load("res://rooms/inventory.tscn")
	inventory_ui = inventory_room.instantiate()
	get_tree().root.call_deferred("add_child", inventory_ui)
	inventory_ui.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#open inventory
func open_inventory() -> void:
	inventory_ui.visible = !inventory_ui.visible

#Time

#calendar
#inventory JSON system
#player status global/local
#level system for unlocking new equipment and seeds
