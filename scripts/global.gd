extends CharacterBody2D

var move_speed : float = 135.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	direction.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	
	velocity = direction * move_speed
	
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#clock 
#calendar
#inventory JSON system
#player status global/local
#level system for unlocking new equipment and seeds
