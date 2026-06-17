extends CharacterBody2D
@export var dialogue_ui: Control
const speed = 30
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum{
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
func _process(delta):
	if is_chatting:
		$AnimatedSprite2D.play("idle")
		return
		
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				$AnimatedSprite2D.play("walk_e")
			else:
				$AnimatedSprite2D.play("walk_w")
		else:
			if velocity.y > 0:
				$AnimatedSprite2D.play("walk_s")
			else:
				$AnimatedSprite2D.play("walk_n")
	else:
		$AnimatedSprite2D.play("idle")
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT,Vector2.UP,Vector2.LEFT,Vector2.DOWN])
			MOVE:
				move(delta)
				
				
func _input(event):
	if event.is_action_pressed("chat") and not event.is_echo():
		if player_in_chat_zone and not is_chatting:
			print("chatting with npc")
			$black_guy_dialog.start()
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("idle")
		
func choose(array):
	array.shuffle()
	return array.front()
	
	
func move(delta):
	if is_chatting:
		velocity = Vector2.ZERO
		return
		
	velocity = dir * speed
	move_and_slide()
		
		
func _on_ending_dialogue_dialogue_finished() -> void:
	$ChoicePanel.visible = true



func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(1.5, 3.0)
	if current_state == IDLE:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		current_state = MOVE
	else:
		velocity = Vector2.ZERO
		current_state = IDLE



func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.name =="player":
		player = body
		body.get_node("Panel").visible = true
		player_in_chat_zone = true
	pass # Replace with function body.


func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		body.get_node("Panel").visible = false
		player_in_chat_zone = false
	pass # Replace with function body.


func _on_black_guy_dialog_dialogue_finished() -> void:
	is_chatting = false
	is_roaming = true
	pass # Replace with function body.


func _on_btn_give_pressed() -> void:
	Global.money -= 30000 
	get_tree().change_scene_to_file("res://rooms/end.tscn")
	pass # Replace with function body.


func _on_btn_refuse_pressed() -> void:
	is_chatting = false
	is_roaming = true
	pass # Replace with function body.
