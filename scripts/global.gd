extends Node

signal global_prices_changed(market_data: Dictionary)
signal money_changed(new_amount)
var from_underground:bool = false
var current_selected_item: String = "Seed_corn"
var selected_item: String = "Seed_corn"
var Room_0 = "res://rooms/room0.tscn"
var Room_1 = "res://rooms/room_1.tscn" # Hall
var Room0_1 = "res://rooms/room0.1.tscn" # Farm
var Room_2 = "res://rooms/room_2.tscn" # Market Store
var Room_3 = "res://rooms/room_3.tscn" # Brewing Lab
var Bedroom = "res://rooms/bedroom.tscn" # Bedroom
var sky_shop = "res://rooms/cloud_shop.tscn"
var liftup = "res://rooms/lift_video(up).tscn"
var liftdown = "res://rooms/lift_video(down).tscn"
var Inventory = "res://rooms/inventory.tscn"
var good_ending = "res://rooms/good_ending.tscn"
# to locate previous room for inventory
var inventory_ui = null
var hotbar_ui = null
var player: Node = null
var current_room: String = ""
var coordinates: String = ""
var seed_to_product: Dictionary = {
    "Seed_corn": "Corn",
    "Seed_chocolate": "Chocolate",
    "Seed_milk": "Milk"
}

var grow_time: Dictionary = {
    "Seed_corn": 10.0,
    "Seed_chocolate": 20.0,
    "Seed_milk": 30.0
}

var setting_room = preload("res://rooms/setting.tscn")

var sound_percent: float = 100.0
var is_muted: bool = false

var current_popup_room0: Node = null

var npc_positions = {}

var time = {} 

var player_name: String = ""

var money: int = 100:
    set(value):
        money = value
        money_changed.emit(money)

var room = {
    "farm": {"scene": Room0_1, "coordinates": "Farm"},
    "room1": {"scene": Room_1, "coordinates": "Room1"},
    "room2": {"scene": Room_2, "coordinates": "Room2"},
    "room3": {"scene": Room_3, "coordinates": "Room3"},
    "sky_shop": {"scene": sky_shop, "coordinates": "SkyShop"},
}

var crops = {
    "Corn": {
        "grow_time": 10,
        "base_price": 5,
        "current_price": 5,
        "stock": 25,
        "ideal": 25,
        "rarity":1
    },
    "Chocolate": {
        "grow_time": 20,
        "base_price": 15,
        "current_price": 15,
        "stock": 20,
        "ideal": 20,
        "rarity": 2
    },
    "Milk": {
        "grow_time": 30,
        "base_price": 25,
        "current_price": 25,
        "stock": 15,
        "ideal": 15,
        "rarity": 3
    },
    "Orange": {
        "grow_time": 40,
        "base_price": 40,
        "current_price": 40,
        "stock": 10,
        "ideal": 10,
        "rarity":4
    },
    "Tomato": {
        "grow_time": 40,
        "base_price": 60,
        "current_price": 60,
        "stock": 5,
        "ideal": 5,
        "rarity":5
    }
}
var seed ={
    "Seed_corn": {
        "base_price": 3,
        "current_price": 3,
        "stock": 25,
        "ideal": 40,
        "rarity":1
    },
    "Seed_chocolate": {
        "base_price": 10,
        "current_price": 10,
        "stock": 25,
        "ideal": 35,
        "rarity": 2
    },
    "Seed_milk": {
        "base_price": 20,
        "current_price": 20,
        "stock": 15,
        "ideal": 30,
        "rarity": 3
    }
}

var flower = {
    "Flower_Red": {
        "base_price": 8,
        "current_price": 1,
        "stock": 10,
        "ideal": 20,
        "rarity":1
    },
    "Flower_Blue": {
        "base_price": 8,
        "current_price": 1,
        "stock": 10,
        "ideal": 20,
        "rarity":1
    },
    "Flower_Yellow": {
        "base_price": 8,
        "current_price": 1,
        "stock": 10,
        "ideal": 20,
        "rarity":1
    },
    "Flower_Purple": {
        "base_price": 8,
        "current_price": 1,
        "stock": 10,
        "ideal": 20,
        "rarity":1
    },
    "Flower_White": {
        "base_price": 8,
        "current_price": 1,
        "stock": 10,
        "ideal": 20,
        "rarity":1
    }
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var inventory_room = load(Inventory)
    inventory_ui = inventory_room.instantiate()
    get_tree().root.call_deferred("add_child", inventory_ui)
    inventory_ui.visible = false
    var hotbar_room = load("res://rooms/Hotbar.tscn")
    hotbar_ui = hotbar_room.instantiate()
    get_tree().root.call_deferred("add_child", hotbar_ui)
    hotbar_ui.visible = false
    Json.load_game()
    apply_volume()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        inventory_ui.visible = false
        if current_popup_room0 != null:
            current_popup_room0.queue_free()
            current_popup_room0 = null

        else:
            current_popup_room0 = setting_room.instantiate()
            get_tree().root.add_child(current_popup_room0)
    elif event.is_action_pressed("tab"):
        var current_scene = get_tree().current_scene.scene_file_path if get_tree().current_scene else ""
        var forbidden_room = "res://rooms/room_0.tscn"
        
        if current_scene == forbidden_room:
            return
        if current_popup_room0 != null:
            current_popup_room0.queue_free()
            current_popup_room0 = null

#open inventory
func open_inventory() -> void:
    inventory_ui.visible = !inventory_ui.visible

#inventory JSON system
#player status global/local

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
