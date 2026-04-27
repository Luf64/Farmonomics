class_name room_3 extends Node

var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$npc/Label.visible = false
	pass
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interaction"):
		print("interacted")
	pass


func _on_tp_to_room_0_1_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().change_scene_to_file("res://rooms/room_1.tscn")
	pass 


func _on_npc_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		$npc/Label.visible = true

func _on_npc_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		$npc/Label.visible = false
