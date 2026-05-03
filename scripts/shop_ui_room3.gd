extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	var room = get_parent()
	room.selling_ui_open = false
	room.selling_ui = null
	queue_free()
	pass # Replace with function body.
