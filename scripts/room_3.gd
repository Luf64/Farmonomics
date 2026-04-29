class_name room_3 extends Node

var player_in_range_npc = false
var player_in_range_tp_room1 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
<<<<<<< HEAD
	pass # Replace with function body.

=======
	$npc/Label.visible = false
	pass
		
>>>>>>> phua


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range_npc and Input.is_action_just_pressed("interaction"):
		print("interacted")
	if player_in_range_tp_room1 and Input.is_action_just_pressed("interaction"):
		get_tree().change_scene_to_file("res://rooms/room_1.tscn")
	pass


func _on_tp_to_room_1_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range_tp_room1 = true
		$"tp to room 1/Panel".visible = true
	pass 

func _on_tp_to_room_1_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range_tp_room1 = false
		$"tp to room 1/Panel".visible = false
	pass # Replace with function body.

func _on_npc_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range_npc = true
		$npc/Panel.visible = true

func _on_npc_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range_npc = false
		$npc/Panel.visible = false
