extends CanvasLayer

@onready var username_input = $Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LineEdit
@onready var video_player = $VideoStreamPlayer

var video_start = preload("res://video/pixel start.ogv")

func _ready():
	username_input.grab_focus()

func _on_button_pressed() -> void:
	var username = username_input.text.strip_edges()
	
	if username == "":
		return
	else:
		Global.player_name = username
		Json.game["money"] = 100
		Json.game["inventory"] = [
			{},{},{},{},{},
			{},{},{},{},{},
			{},{},{},{},{},
			{},{},{},{},{},
			{},{},{},{},{},
			{},{},{},{},{},
		]
		Json.game["scene"] = Global.Room_1
		Global.money = 100
		Json.save_game()
		Global.inventory_ui.refresh()
		Global.hotbar_ui.refresh()
		Json.save_game()
		$Control.visible = false
		video_player.visible = true
		video_player.play()
		

func _on_video_finished():
	video_player.visible = false
	Global.hotbar_ui.visible = true
	if Global.current_popup_room0 == self:
		Global.current_popup_room0 = null
	get_tree().change_scene_to_file(Global.Room_1)
	queue_free()


func _on_close_button_pressed() -> void:
	if Global.current_popup_room0 == self:
		Global.current_popup_room0 = null
	queue_free()
