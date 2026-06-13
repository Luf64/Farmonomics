extends CanvasLayer

func _on_close_button_pressed() -> void:
	queue_free()

func _on_yes_pressed() -> void:
	Json.save_game()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_no_pressed() -> void:
	queue_free()
