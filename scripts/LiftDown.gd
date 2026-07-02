extends VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hotbar_ui.visible = false
	play()

func _on_finished() -> void:
	Json.save_game()
	get_tree().change_scene_to_file(Global.Room_1)
	Json.load_game()
	Global.hotbar_ui.visible = true
