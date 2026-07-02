extends Node2D

@onready var prompt: Label = $InteractionPrompt
var player_in_range: bool = false

func trigger_sleep() -> void:
	if not Timemanager.can_player_sleep():
		print("not tired enough to sleep yet")
		return

	print("sleeping...")
	get_tree().call_group("TimeSystem", "player_sleep")

	if prompt:
		prompt.visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interaction"):
		trigger_sleep()


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		player_in_range = true
		if prompt:
			prompt.visible = true 
	pass # Replace with function body.


func _on_area_2d_3_body_exited(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		player_in_range = false
		if prompt:
			prompt.visible = false
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Json.save_game()
		Global.current_room = "Bedroom"
		Global.coordinates = "Farm"
		get_tree().change_scene_to_file(Global.Room_1)
		Json.load_game()
	pass # Replace with function body.
