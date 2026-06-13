extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_continue_pressed() -> void:
	Global.hotbar_ui.visible =! Global.hotbar_ui.visible
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
		

var quit_page = preload("res://rooms/quit_game.tscn")

func _on_quit_game_pressed() -> void:
	var page_quit = quit_page.instantiate()
	add_child(page_quit)

var credits_page = preload("res://rooms/Credit.tscn")

func _on_credits_pressed() -> void:
	var page_credit = credits_page.instantiate()
	add_child(page_credit)
