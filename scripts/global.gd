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
    "Corn": 10.0,
    "Chocolate": 20.0,
    "Milk": 30.0
}

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
        Json.save_game()
        await get_tree().create_timer(1.0).timeout
        get_tree().quit()

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

# player starting money
