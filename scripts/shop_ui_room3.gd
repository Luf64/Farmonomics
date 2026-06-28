extends Node

func _on_close_pressed() -> void:
    var room = get_parent()
    room.selling_ui_open = false
    room.selling_ui = null
    queue_free()
    pass # Replace with function body.
