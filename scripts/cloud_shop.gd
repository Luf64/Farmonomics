extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var frames = [
	preload("res://Assets/lift_1.png"),
	preload("res://Assets/lift_2.png"),
	preload("res://Assets/lift_3.png")
]

func _ready() -> void:
	sprite.texture = frames[0]

func _on_animation_body_entered(body: Node2D) -> void:
	if body.name == "player":
		sprite.texture = frames[0]
		await get_tree().create_timer(1.0).timeout
		sprite.texture = frames[1]
		await get_tree().create_timer(1.0).timeout
		sprite.texture = frames[2]


func _on_animation_body_exited(body: Node2D) -> void:
	if body.name == "player":
		sprite.texture = frames[2]
		await get_tree().create_timer(1.0).timeout
		sprite.texture = frames[1]
		await get_tree().create_timer(1.0).timeout
		sprite.texture = frames[0]


func _on_lift_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_lift_door_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
