extends Area2D

func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        Json.save_game()
        Global.from_underground = true
        get_tree().current_scene.save_all_plant()
        get_tree().change_scene_to_file(Global.Bedroom)
        Json.load_game()
