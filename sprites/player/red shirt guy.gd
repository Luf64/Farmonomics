class_name red_shirt_guy extends CharacterBody2D
@onready var run_sound: AudioStreamPlayer2D = $Run
var sound_volume: float
var move_speed : float = 135.0
var sprint_speed : float = 210.0
var last_direction : Vector2 = Vector2.DOWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure sound not play
	if run_sound:
		sound_volume
		run_sound.autoplay = false
		run_sound.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var direction : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	
	var current_speed = move_speed
	
	# hold"Shift" 
	if Input.is_action_pressed("Shift(run)") and direction != Vector2.ZERO:
		current_speed = sprint_speed
		run_sound.pitch_scale = 1.3  
	else:
		run_sound.pitch_scale = 1.0  
	
	
	velocity = direction.normalized() * current_speed
	
	if direction != Vector2.ZERO:
		if not run_sound.playing:
			run_sound.play()
	else:
		#if stop moving, sound stop
		if run_sound.playing:
			run_sound.stop()
	
		# update last direction when moving
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
		pass #open_inventory() -- Bug
		
	move_and_slide()
	pass


'''func open_inventory() -> void:
	Global.open_inventory(get_tree().current_2ene_file_path)'''
