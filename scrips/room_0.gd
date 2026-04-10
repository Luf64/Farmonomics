extends Node2D

@onready var settings1 = $Settings1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/room_1.tscn")


func _on_settings_pressed() -> void:
	settings1.show()

func _on_exit_pressed() -> void:
	get_tree().quit()
