extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(Global.Room_1)

func _on_new_game_pressed() -> void:
	pass # Replace with function body.
	
func _on_settings_pressed() -> void:
	setting_page()
	pass # Replace with function body.

func setting_page():
	if not Global.setting_open:
		Global.setting = Global.setting_room.instantiate()
		call_deferred("add_child", Global.setting)
		Global.setting_open = true
	else:
		Global.setting.queue_free()
		Global.setting = null
		Global.setting_open = false
		
	

func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/Credit.tscn")
