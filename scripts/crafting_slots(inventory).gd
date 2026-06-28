extends Panel

signal item_pressed(slot_number: int)

@export var slot_number: int = 0
var has_item: bool = false  

func _on_icon_pressed() -> void:
	if has_item:
		item_pressed.emit(slot_number)
