class_name red_shirt_guy extends CharacterBody2D

var move_speed : float = 135.0
var last_direction : Vector2 = Vector2.DOWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	var direction : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	velocity = direction * move_speed
	
		# update the last direction
	if direction != Vector2.ZERO:
		last_direction = direction
	
	#animation
	if direction.x > 0:
		$AnimationPlayer.play("walk_right")
	elif direction.x < 0:
		$AnimationPlayer.play("walk_left")
	elif direction.y > 0:
		$AnimationPlayer.play("walk_down")
	elif direction.y < 0:
		$AnimationPlayer.play("walk_up")
	else:
		if last_direction.x > 0:
			$AnimationPlayer.play("idle_right")
		if last_direction.x < 0:
			$AnimationPlayer.play("idle_left")
		if last_direction.y > 0:
			$AnimationPlayer.play("idle_down")
		if last_direction.y < 0:
			$AnimationPlayer.play("idle_up")
	
	if Input.is_action_just_pressed("tab"):
		open_inventory()
	
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move_and_slide()

func open_inventory() -> void:
	Global.open_inventory(get_tree().current_scene.scene_file_path)
