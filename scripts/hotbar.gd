extends CanvasLayer

@onready var container = $Control/GridContainer
var selected_slot: int = 0

var item_textures = {
    "Seed_corn":preload("res://Assets/item/Corn/Seed_corn.png"),
    "Seed_chocolate":preload("res://Assets/item/Chocolate/Seed_chocolate.png"),
    "Seed_milk":preload("res://Assets/item/Milk/Seed_milk.png"),
    
    "Corn": preload("res://Assets/item/Corn/corn(Object).png"),
    "Chocolate": preload("res://Assets/item/Chocolate/chocolate(Object).png"),
    "Milk": preload("res://Assets/item/Milk/milk(Object).png"),
    
    "Apple": preload("res://Assets/item/apple (1).png"),
    "Tomato": preload("res://Assets/item/Tomato.png"),
    "Potato": preload("res://Assets/item/potato.png"),
    "Orange": preload("res://Assets/item/Orange.png"),
    "Flower_Red": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Red.png"),
    "Flower_Yellow": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Yellow.png"),
    "Flower_Blue": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Blue.png"),
    "Flower_Purple": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Purple.png"),
    "Flower_White": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_White.png"),
    "Potion_Red": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon1.png"),
    "Potion_Yellow": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon2.png"),
    "Potion_Blue": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon9.png"),
    "Potion_Purple": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon15.png"),
    "Potion_White": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon17.png")
}

func _ready() -> void:
    var slot = container.get_children()
    for i in slot.size():
        slot[i].slot_number = i
    select_slot(0)
    refresh()
    _setup_potion_timers()


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("1"):
        select_slot(0)
    elif event.is_action_pressed("2"):
        select_slot(1)
    elif event.is_action_pressed("3"):
        select_slot(2)
    elif event.is_action_pressed("4"):
        select_slot(3)
    elif event.is_action_pressed("5"):
        select_slot(4)
    elif event.is_action_pressed("use_potion"):
        use_selected_potion()

func select_slot(number:int) -> void:
        var slot = container.get_children()
        slot[selected_slot].get_node("ColorRect").visible = false
        selected_slot = number
        slot[selected_slot].get_node("ColorRect").visible = true
        var inventory = Json.get_inventory()
        if number < inventory.size() and inventory[number].has("id"):
            Global.current_selected_item = inventory[number]["id"]
        else:
            Global.current_selected_item = ""
        return

func refresh() -> void:
    var inventory = Json.get_inventory()
    var slot = container.get_children()
    
    for i in slot.size():
        var icon = slot[i].get_node("Icon")
        var count = slot[i].get_node("Count")
        if inventory.size()>i and inventory[i].has("id"):
            var item_id = inventory[i]["id"]
            count.text = str(int(inventory[i]["amount"]))
            if item_textures.has(item_id):
                icon.texture = item_textures[item_id]
            else:
                icon.texture = null
        else:
            count.text = ""
            icon.texture = null
    if selected_slot < inventory.size() and inventory[selected_slot].has("id"):
        Global.current_selected_item = inventory[selected_slot]["id"]
    else:
        Global.current_selected_item = ""

func use_selected_potion() -> void:
    var item_id = Global.current_selected_item
    if item_id == "" or not item_id.begins_with("Potion_"):
        return

    if Global.player == null:
        print("No player reference set, cannot apply potion")
        return

    match item_id:
        "Potion_Red":
            apply_big()
        "Potion_Yellow":
            apply_speed(2.0)
        "Potion_White":
            apply_speed(3.0)
        "Potion_Purple":
            apply_invisible()
        "Potion_Blue":
            reset_player_effects()
        _:
            return
    consume_selected_potion()

func consume_selected_potion() -> void:
    var inventory = Json.get_inventory()
    if selected_slot >= inventory.size():
        return
    var slot_data = inventory[selected_slot]
    if not slot_data.has("amount"):
        return
    
    slot_data["amount"] -= 1
    if slot_data["amount"] <= 0:
        inventory[selected_slot] = {}
    
    Json.save_game()
    if Global.inventory_ui:
        Global.inventory_ui.refresh()
    if Global.hotbar_ui:
        Global.hotbar_ui.refresh()

var is_big: bool = false
var speed_multiplier: float = 1.0
var is_invisible: bool = false

var potion_timers: Dictionary = {}

func _setup_potion_timers() -> void:
    for key in ["big", "speed", "invisible"]:
        var t = Timer.new()
        t.one_shot = true
        add_child(t)
        potion_timers[key] = t

    potion_timers["big"].timeout.connect(_on_big_timeout)
    potion_timers["speed"].timeout.connect(_on_speed_timeout)
    potion_timers["invisible"].timeout.connect(_on_invisible_timeout)

func apply_big() -> void:
    is_big = true
    Global.player.scale = Global.player.base_scale * 3.0
    potion_timers["big"].start(20.0)

func apply_speed(multiplier: float) -> void:
    speed_multiplier = multiplier
    Global.player.move_speed = Global.player.base_move_speed * multiplier
    potion_timers["speed"].start(20.0)

func apply_invisible() -> void:
    is_invisible = true
    Global.player.modulate.a = 0.0
    potion_timers["invisible"].start(20.0)

func reset_player_effects() -> void:
    is_big = false
    speed_multiplier = 1.0
    is_invisible = false
    for key in potion_timers:
        potion_timers[key].stop()
    if Global.player == null:
        return
    Global.player.scale = Global.player.base_scale
    Global.player.move_speed = Global.player.base_move_speed
    Global.player.modulate.a = 1.0

func _on_big_timeout() -> void:
    is_big = false
    if Global.player:
        Global.player.scale = Global.player.base_scale

func _on_speed_timeout() -> void:
    speed_multiplier = 1.0
    if Global.player:
        Global.player.move_speed = Global.player.base_move_speed

func _on_invisible_timeout() -> void:
    is_invisible = false
    if Global.player:
        Global.player.modulate.a = 1.0

func apply_active_effects_to_player() -> void:
    if Global.player == null:
        return
    Global.player.scale = Global.player.base_scale * (3.0 if is_big else 1.0)
    Global.player.move_speed = Global.player.base_move_speed * speed_multiplier
    Global.player.modulate.a = 0.0 if is_invisible else 1.0
