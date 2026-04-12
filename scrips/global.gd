extends CharacterBody2D

@export var speed = 400
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

#clock 
#calendar
#inventory JSON system
#player status global/local
#level system for unlocking new equipment and seeds
