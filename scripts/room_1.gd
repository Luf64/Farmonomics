extends Area2D

var player_in_range = false

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interaction"):
		Global.current_room = "sky_shop"
		get_tree().change_scene_to_file(Global.sky_shop)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if name == "Farm Door":
			Global.current_room = "farm"
			get_tree().change_scene_to_file(Global.Room0_1)
		elif name == "Room3 Door":
			Global.current_room = "room3"
			get_tree().change_scene_to_file(Global.Room_3)
		elif name == "Room2 Door":
			Global.current_room = "room2"
			get_tree().change_scene_to_file(Global.Room_2)
		elif name == "lift door":
			$Panel.visible = true
			player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if name == "lift door":
			$Panel.visible = false
