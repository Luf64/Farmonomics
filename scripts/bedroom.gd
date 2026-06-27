extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.current_room = "room1"
		get_tree().change_scene_to_file("res://rooms/room_1.tscn")
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.current_room = "room0.1"
		get_tree().change_scene_to_file("res://rooms/room0.1.tscn")
	pass # Replace with function body.
