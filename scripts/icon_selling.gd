extends Panel

signal sell_pressed(slot_number: int)

@export var slot_number: int = 0
var sellable: bool = false

func _on_icon_pressed() -> void:
	print("Clicked slot ", slot_number, " sellable=", sellable)
	if sellable:
		sell_pressed.emit(slot_number)
