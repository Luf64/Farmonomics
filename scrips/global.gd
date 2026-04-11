extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
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
