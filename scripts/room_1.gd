extends Area2D
func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        if name == "Farm Door":
            Json.load_game()
            Global.current_room = "farm"
            get_tree().change_scene_to_file(Global.Room0_1)
        elif name == "Room3 Door":
            Json.load_game()
            Global.current_room = "room3"
            get_tree().change_scene_to_file(Global.Room_3)
        elif name == "Room2 Door":
            Json.load_game()
            Global.current_room = "room2"
            get_tree().change_scene_to_file(Global.Room_2)
