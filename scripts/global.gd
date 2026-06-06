extends Node

signal global_prices_changed(market_data: Dictionary)
signal money_changed(new_amount)

var current_selected_item: String = "Corn"
var selected_item: String = "Corn"
var item_textures: Dictionary = {}

var Room_1 = "res://rooms/room_1.tscn" #Hall
var Room0_1 = "res://rooms/room0.1.tscn" # Farm
var Room_2 = "res://rooms/room_2.tscn" # Market Store
var Room_3 = "res://rooms/room_3.tscn" # Brewing Lab
var Inventory = "res://rooms/inventory.tscn"
# to locate previous room for inventory
var inventory_ui = null
var current_room: String = ""
var coordinates: String = ""

var money: int = 100:
	set(value):
		money = value
		money_changed.emit(money)

var room = {
	"farm" : {"scene": Room0_1, "coordinates": "Farm"},
	"room1": {"scene": Room_1,"coordinates":"Room1"},
	"room2": {"scene": Room_2,"coordinates":"Room2"},
	"room3": {"scene": Room_3,"coordinates":"Room3"}
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory_room = load(Inventory)
	inventory_ui = inventory_room.instantiate()
	get_tree().root.call_deferred("add_child", inventory_ui)
	inventory_ui.visible = false
	Json.load_game()
	#testing
	if Json.get_item_count("Corn") == 0:
		Json.add_item("Corn",5)
	if Json.get_item_count("Chocolate") == 0:
		Json.add_item("Chocolate", 5)
	if Json.get_item_count("Milk") == 0:
		Json.add_item("Milk", 5)
	current_selected_item = "Corn"
	selected_item = "Corn"
	selected_item = "Corn"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Json.save_game()
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
	#test
	if event.is_action_pressed("1"):
		current_selected_item = "Corn"
		selected_item = "Corn"
		print("Selected: Corn")
	if event.is_action_pressed("2"):
		current_selected_item = "Chocolate"
		selected_item = "Chocolate"
		print("Selected: Chocolate")
	if event.is_action_pressed("3"):
		current_selected_item = "Milk"
		selected_item = "Milk"
		print("Selected:  Milk")

#open inventory
func open_inventory() -> void:
	inventory_ui.visible = !inventory_ui.visible

#inventory JSON system
#player status global/local
#level system for unlocking new equipment and seeds


func subtract_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		money_changed.emit(money) 
		return true
	else:
		return false

# player starting money
