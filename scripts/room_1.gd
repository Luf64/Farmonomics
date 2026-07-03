extends Area2D
var player_in_range = false
func _process(delta: float) -> void:
    if player_in_range and Input.is_action_just_pressed("interaction"):
        Global.current_room = "sky_shop"
        Json.save_game()
        get_tree().change_scene_to_file(Global.liftup)
        Json.load_game()
func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        if name == "Farm Door":
            Global.current_room = "farm"
            Json.save_game()
            get_tree().call_deferred("change_scene_to_file", Global.Bedroom)
            Json.load_game()
        elif name == "Room3 Door":
            Global.current_room = "room3"
            Json.save_game()
            get_tree().call_deferred("change_scene_to_file", Global.Room_3)
            Json.load_game()
        elif name == "Room2 Door":
            Global.current_room = "room2"
            Json.save_game()
            get_tree().call_deferred("change_scene_to_file", Global.Room_2)
            Json.load_game()
        elif name == "lift door":
            $Panel.visible = true
            player_in_range = true
func _on_body_exited(body: Node2D) -> void:
    if body.name == "player":
        if name == "lift door":
            $Panel.visible = false
 
