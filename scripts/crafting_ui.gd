class_name crafting_ui extends CanvasLayer

@onready var craft_grid = $Control/craftingGrid
@onready var result_panel = $"Control/result_PanelContainer"
@onready var result_icon = $"Control/result_PanelContainer/resultItem"
@onready var result_label = $"Control/resultLabel"

var current_items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("crafting_ui")
    var inventory = Json.get_inventory()
'''
	for item in inventory:
		print(item["id"])
		print(item["amount"])
	pass # Replace with function body.
'''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

var recipes = {
    "flower_red": "healing_potion",
    "flower_blue": "mana_potion",
    "flower_white": "white_potion",
    "flower_yellow": "yellow_potion",
    "flower_purple": "purple_potion",
    "flower_red,flower_red": "big_healing_potion",
    "Chocolate,Milk": "chocolate_milk"
}

var result_textures = {
    "healing_potion": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon1.png"),
    "mana_potion": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon2.png")
}

func craft():

    var sorted_items = current_items.duplicate()
    sorted_items.sort()
    
    var key = ",".join(sorted_items)
    
    clear_craft()
    
    if recipes.has(key):
        var result_name = recipes[key]
        var texture = result_textures.get(result_name, null)
        show_result(result_name, texture)
        return
    else:
        print("No recipe found")
        var result_name = ("No recipe found")
        show_result(result_name)



func show_result(result_name: String, texture: Texture2D = null):
    print("Crafted: ", result_name)
    
    result_panel.visible = true
    result_label.text = result_name

    if texture != null:
        result_icon.texture = texture

func add_item_to_craft(item_name: String, item_texture: Texture2D):
    if current_items.size() >= 9:
        return

    current_items.append(item_name)

    for slot in craft_grid.get_children():
        if slot.get_child_count() == 0:
            var icon = TextureRect.new()
            icon.texture = item_texture
            icon.custom_minimum_size = Vector2(64, 64)
            icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
            icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

            # store item info in slot
            slot.set_meta("item_name", item_name)

            # make clickable
            var btn = Button.new()
            btn.text = ""
            btn.flat = true
            btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
            btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
            
            btn.pressed.connect(remove_item_from_slot.bind(slot))
            
            slot.add_child(icon)
            slot.add_child(btn)
            return

func remove_item_from_slot(slot):
    if not slot.has_meta("item_name"):
        return
    
    var item_name = slot.get_meta("item_name")
    
    # remove from array
    current_items.erase(item_name)
    
    # clear slot UI
    for child in slot.get_children():
        child.queue_free()
        
    slot.remove_meta("item_name")


func clear_craft():
    print("clear")
    current_items.clear()
    
    for slot in craft_grid.get_children():
        for child in slot.get_children():
            child.queue_free()
    
    result_icon.texture = null
    result_label.text = ""

func _on_close_pressed() -> void:
    var room = get_parent()
    room.crafting_ui_open = false
    room.crafting_ui = null
    queue_free()
    pass # Replace with function body.


func _on_craft_texture_button_pressed() -> void:
    craft()
