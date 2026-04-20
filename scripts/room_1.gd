extends Area2D
var Room0_1 = "res://rooms/room0.1.tscn"
var Room_3 = "res://rooms/room_3.tscn"
func _on_body_entered(body: Node2D) -> void:
	if name == "Farm Door":
		get_tree().change_scene_to_file(Room0_1)
	elif name == "Room3 Door":
		get_tree().change_scene_to_file(Room_3)
