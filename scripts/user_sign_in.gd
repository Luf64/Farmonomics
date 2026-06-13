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
		$Control.visible = false
		video_player.visible = true
		video_player.play()

func _on_video_finished():
	Global.hotbar_ui.visible = !Global.hotbar_ui.visible
	video_player.visible = false
	get_tree().change_scene_to_file(Global.Room_1)

func _on_close_button_pressed() -> void:
	queue_free()
