extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.current_room = "room1"
		get_tree().change_scene_to_file(Global.Room_1)
