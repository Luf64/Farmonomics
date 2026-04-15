class_name red_shirt_guy extends CharacterBody2D

var move_speed : float = 135.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	direction.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
	
	velocity = direction * move_speed
	
	pass


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move_and_slide()
