extends Button


func _on_pressed() -> void:
	close_shop()
	
func close_shop():
	get_tree().paused = false
	get_owner().queue_free()
