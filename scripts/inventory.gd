extends CanvasLayer

@onready var json = get_node("/root/json")
@onready var container = $Control/GridContainer

func _ready() -> void:
	add_to_group("inventory_ui")

func _on_texture_button_pressed():
	Global.open_inventory()
