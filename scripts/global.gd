extends Node
var Room_1 = "res://rooms/room_1.tscn" #Hall
var Room0_1 = "res://rooms/room0.1.tscn" # Farm
var Room_2 = "res://rooms/room_2.tscn" # Market Store
var Room_3 = "res://rooms/room_3.tscn" # Brewing Lab
var Inventory = "res://rooms/inventory.tscn"
# to locate previous room for inventory
var inventory_ui = null
var coordinates: String = ""
var room = {
	"farm" : {"scene": Room0_1, "coordinates": "Farm"},
	"room1": {"scene": Room_1,"coordinates":"Room1"},
	"room2": {"scene": Room_2,"coordinates":"Room2"},
	"room3": {"scene": Room_3,"coordinates":"Room3"}
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory_room = load(Global.Inventory)
	inventory_ui = inventory_room.instantiate()
	get_tree().root.call_deferred("add_child", inventory_ui)
	inventory_ui.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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
