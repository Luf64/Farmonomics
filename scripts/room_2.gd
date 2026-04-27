class_name room_2 extends Node


var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop_UI/interaction.visible = false
	pass # Replace with function body.
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interaction"):
		print("interacted")
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().change_scene_to_file("res://rooms/room_1.tscn")
	pass # Replace with function body.



func _on_shop_ui_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		$Shop_UI/interaction.visible = true


func _on_shop_ui_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		$Shop_UI/interaction.visible = false
