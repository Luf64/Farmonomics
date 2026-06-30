extends Panel
# crafting_slot.gd

signal slot_pressed(slot_number: int)

@export var slot_number: int = 0
var item_name: String = ""
var has_item: bool = false

@onready var icon = $Icon

func set_item(name: String, texture: Texture2D) -> void:
    item_name = name
    has_item = true
    icon.texture_normal = texture
    icon.visible = true

func clear_item() -> void:
    item_name = ""
    has_item = false
    icon.texture_normal = null
    icon.visible = false

func _on_icon_pressed() -> void:
    if has_item:
        slot_pressed.emit(slot_number)
