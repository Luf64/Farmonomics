extends Area2D

var player_in_range = false


func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        Json.save_game()
        get_tree().call_deferred("change_scene_to_file", Global.Room0_1)
