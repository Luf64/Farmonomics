extends VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.hotbar_ui.visible = false
    play()

func _on_finished() -> void:
    get_tree().change_scene_to_file("res://rooms/room_0.tscn")
