extends Node

signal global_prices_changed(market_data: Dictionary)
signal money_changed(new_amount)

var current_selected_item: String = "Corn"
var selected_item: String = "Corn"
var Room_1 = "res://rooms/room_1.tscn" #Hall
var Room0_1 = "res://rooms/room0.1.tscn" # Farm
var Room_2 = "res://rooms/room_2.tscn" # Market Store
var Room_3 = "res://rooms/room_3.tscn" # Brewing Lab
var Inventory = "res://rooms/inventory.tscn"
# to locate previous room for inventory
var inventory_ui = null
var hotbar_ui = null
var current_room: String = ""
var coordinates: String = ""
var grow_time: Dictionary = {
	"Seed_corn": 10.0,
	"Seed_chocolate": 20.0,
	"Seed_milk": 30.0
}

var setting_open = false 
var setting = null 
var setting_room = preload("res://rooms/setting.tscn") 

var sound_percent: float = 100.0
var is_muted: bool = false

var current_popup_room0: Node = null


var player_name: String = ""

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
	
	var hotbar_room = load("res://rooms/hotbar.tscn")
	hotbar_ui = hotbar_room.instantiate()
	get_tree().root.call_deferred("add_child",hotbar_ui)
	hotbar_ui.visible = false
	Json.load_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if current_popup_room0 != null:
			current_popup_room0.queue_free()
			current_popup_room0 = null
		else:
			current_popup_room0 = setting_room.instantiate()
			get_tree().root.add_child(current_popup_room0)

func toggle_settings():
	if not setting_open:
		setting = setting_room.instantiate()
		get_tree().root.add_child(setting)
		setting_open = true
	else:
		if setting:
			setting.queue_free()
			setting = null
		setting_open = false

#open inventory
func open_inventory() -> void:
	inventory_ui.visible = ! inventory_ui.visible

#inventory JSON system
#player status global/local
#crops
var crops = {
	"Corn": {
		"grow_time": 10,
		"base_price": 1,
		"current_price": 1,
		"stock": 50,
		"ideal": 50
		},
	"Chocolate": {
		"grow_time": 10,
		"base_price": 3,
		"current_price": 3,
		"stock": 40,
		"ideal": 40
		},
	"Milk": {
		"grow_time": 10,
		"base_price": 3,
		"current_price": 3,
		"stock": 30,
		"ideal": 30
		},
	"Orange": {
		"grow_time": 10,
		 "base_price": 30,
		"current_price": 30,
		 "stock": 40,
		 "ideal": 40
		},
	"Potato": 
		{"grow_time": 10, 
		"base_price": 15, 
		"current_price": 15,
		"stock": 35, 
		"ideal": 35
		},
		"Tomato": 
		{"grow_time": 10, 
		"base_price": 15, 
		"current_price": 15,
		"stock": 35, 
		"ideal": 35
		}
		
}


func subtract_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		money_changed.emit(money) 
		return true
	else:
		return false

func apply_volume():
	var bus = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_mute(bus, is_muted)
	
	if is_muted:
		return
	
	var db = linear_to_db(sound_percent / 100.0)
	AudioServer.set_bus_volume_db(bus, db)

func open_popup_room0(scene: PackedScene):
	# if something already open → close it first
	if current_popup_room0 != null:
		current_popup_room0.queue_free()
		current_popup_room0 = null

	# open new popup
	current_popup_room0 = scene.instantiate()
	get_tree().root.add_child(current_popup_room0)

# player starting money
