class_name crafting_ui
extends CanvasLayer

@onready var craft_grid = $Control/craftingGrid
@onready var inventory_grid = $Control/"inventory GridContainer"
@onready var result_panel = $"Control/result_PanelContainer"
@onready var result_icon = $"Control/result_PanelContainer/resultItem"
@onready var result_label = $"Control/resultLabel"

var current_items = []
var slot_order = []

var item_textures = {
    "Seed_corn": preload("res://Assets/item/Corn/Seed_corn.png"),
    "Seed_chocolate": preload("res://Assets/item/Chocolate/Seed_chocolate.png"),
    "Seed_milk": preload("res://Assets/item/Milk/Seed_milk.png"),
    "Corn": preload("res://Assets/item/Corn/corn(Object).png"),
    "Chocolate": preload("res://Assets/item/Chocolate/chocolate(Object).png"),
    "Milk": preload("res://Assets/item/Milk/milk(Object).png"),
    "Tomato": preload("res://Assets/item/Tomato.png"),
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

var recipes = {
    "Flower_Red": "Potion_Red",
    "Flower_Blue": "Potion_Blue",
    "Flower_White": "Potion_White",
    "Flower_Yellow": "Potion_Yellow",
    "Flower_Purple": "Potion_Purple",
}

func _ready() -> void:
    add_to_group("crafting_ui")

    var slots = craft_grid.get_children()
    for i in slots.size():
        slots[i].slot_number = i
        slots[i].slot_pressed.connect(remove_item_from_slot)

    var inv_slots = inventory_grid.get_children()
    for i in inv_slots.size():
        inv_slots[i].slot_number = i
        inv_slots[i].item_pressed.connect(_on_inventory_slot_pressed)
    refresh_inventory()

func refresh_inventory() -> void:
    var inventory = Json.get_inventory()
    var slot = inventory_grid.get_children()
    for i in slot.size():
        var icon = slot[i].get_node("Icon")
        var count = slot[i].get_node("Count")
        if inventory.size() > i and inventory[i].has("id"):
            var item_id = inventory[i]["id"]
            count.text = str(int(inventory[i]["amount"]))
            if item_textures.has(item_id):
                icon.texture_normal = item_textures[item_id]
            else:
                icon.texture_normal = null
            slot[i].has_item = true
        else:
            count.text = ""
            icon.texture_normal = null
            slot[i].has_item = false

func _on_inventory_slot_pressed(slot_number: int) -> void:
    var inventory = Json.get_inventory()
    if slot_number >= inventory.size() or inventory[slot_number].is_empty():
        return

    var item_id = inventory[slot_number]["id"]
    var texture = item_textures.get(item_id, null)
    add_item_to_craft(item_id, texture)

func craft():
    var sorted_items = current_items.duplicate()
    sorted_items.sort()
    var key = ",".join(sorted_items)

    if recipes.has(key):
        var result_name = recipes[key]
        var texture = item_textures.get(result_name, null)
        for item_id in current_items:
            Json.remove_item(item_id, 1)
        Json.add_item(result_name, 1)
        clear_craft()
        show_result(result_name, texture)
        refresh_inventory()
        if Global.inventory_ui:
            Global.inventory_ui.refresh()
        if Global.hotbar_ui:
            Global.hotbar_ui.refresh()
    else:
        clear_craft()
        print("No recipe found")
        show_result("No recipe found")

func show_result(result_name: String, texture: Texture2D = null) -> void:
    print("Crafted: ", result_name)
    result_panel.visible = true
    result_label.text = result_name
    result_icon.texture = texture

func add_item_to_craft(item_name: String, item_texture: Texture2D) -> void:
    if current_items.size() >= craft_grid.get_child_count():
        return
    for slot in craft_grid.get_children():
        if not slot.has_item:
            current_items.append(item_name)
            slot.set_item(item_name, item_texture)
            return

func remove_item_from_slot(slot_number: int) -> void:
    var slot = craft_grid.get_children()[slot_number]
    if not slot.has_item:
        return
    current_items.erase(slot.item_name)
    slot.clear_item()

func clear_craft() -> void:
    print("clear")
    current_items.clear()
    for slot in craft_grid.get_children():
        slot.clear_item()
    result_icon.texture = null
    result_label.text = ""

func _on_close_pressed() -> void:
    var room = get_parent()
    room.crafting_ui_open = false
    room.crafting_ui = null
    queue_free()

func _on_craft_texture_button_pressed() -> void:
    craft()
