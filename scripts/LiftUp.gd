extends VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()

func _on_finished() -> void:
	get_tree().change_scene_to_file(Global.sky_shop)
