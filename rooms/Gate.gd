extends Area2D
var Room0_1 = "res://room0.1.tscn"

func _on_body_entered(body: Node2D) -> void:
	if name == "Area":
		get_tree().change_scene_to_file(Room0_1)
