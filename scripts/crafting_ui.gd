class_name crafting_ui extends CanvasLayer

@onready var craft_grid = $Control/craftingGrid

var current_items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("crafting_ui")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

var recipes = {
    ["flower_red"]: "healing_potion",
    ["flower_blue"]: "mana_potion",
    ["flower_white"]: "white_potion",
    ["flower_yellow"]: "yellow_potion",
    ["flower_purple"]: "purple_potion",
}

func craft():
    var sorted_items = current_items.duplicate()
    sorted_items.sort()

    for recipe in recipes.keys():
        var sorted_recipe = recipe.duplicate()
        sorted_recipe.sort()

        if sorted_recipe == sorted_items:
            var result = recipes[recipe]
            show_result(result)
            return

    print("No recipe found")

func show_result(result_name):
    print("Crafted: ", result_name)
    clear_craft()

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
            slot.add_child(icon)
            return

func clear_craft():
    print("clear")
    current_items.clear()

    for slot in craft_grid.get_children():
        for child in slot.get_children():
            child.queue_free()

func _on_close_pressed() -> void:
    var room = get_parent()
    room.crafting_ui_open = false
    room.crafting_ui = null
    queue_free()
    pass # Replace with function body.


func _on_craft_button_pressed() -> void:
    craft()
