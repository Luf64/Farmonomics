extends Node2D

func _on_continue_pressed() -> void:
    Json.save_game()
    Global.hotbar_ui.visible =! Global.hotbar_ui.visible
    get_tree().change_scene_to_file(Global.Room_1)
    Json.load_game()

var newgame = preload("res://rooms/user_sign_in.tscn")
func _on_new_game_pressed() -> void:
    Global.open_popup_room0(newgame)

func _on_settings_pressed() -> void:
    Global.open_popup_room0(Global.setting_room)
    pass # Replace with function body.

var quit_page = preload("res://rooms/quit_game.tscn")

func _on_quit_game_pressed() -> void:
    Global.open_popup_room0(quit_page)

var credits_page = preload("res://rooms/Credit.tscn")

func _on_credits_pressed() -> void:
    Global.open_popup_room0(credits_page)
