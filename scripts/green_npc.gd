extends CharacterBody2D
#@export var house_node: Node2D
@export var home_path: Array[Node2D] 
var current_path_index = 0
@export var home_tolerance = 5.0
@export var dialogue_ui: Control
const speed = 30
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos
var is_raining = false

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum{
    IDLE,
    NEW_DIR,
    MOVE,
    GO_HOME,
    INSIDE_HOUSE
}

func _ready():
    randomize()
    if Global.npc_positions.has(self.name):
        self.global_position = Global.npc_positions[self.name]
    start_pos = position
    
func _process(delta):
    if current_state == INSIDE_HOUSE:
        visible = false
        velocity = Vector2.ZERO
        return
    else:
        visible = true
    
    
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
                
    if current_state == GO_HOME:
        move_home(delta)

func _input(event):
    if event.is_action_pressed("chat") and not event.is_echo():
        if player_in_chat_zone and not is_chatting and current_state != INSIDE_HOUSE:
            if is_raining:
                run_dialogue("Natasha Rain")
            else:
                run_dialogue("Natasha Chatting")
            $AnimatedSprite2D.play("idle")
            get_viewport().set_input_as_handled()
        
        
func run_dialogue(dialogue_string):
    
    is_chatting = true
    is_roaming = false
    
    Dialogic.start(dialogue_string)
    if not Dialogic.timeline_ended.is_connected(_on_dialogic_ended):
        Dialogic.timeline_ended.connect(_on_dialogic_ended)
    
    
    

func choose(array):
    array.shuffle()
    return array.front()
    
    

    
func move(delta):
    if is_chatting:
        velocity = Vector2.ZERO
        return
        
    velocity = dir * speed
    move_and_slide()
        
        


func _on_chat_detetion_area_body_entered(body: Node2D) -> void:
    if body.name =="player":
        player = body
        body.get_node("Panel").visible = true
        player_in_chat_zone = true
        

func _on_chat_detetion_area_body_exited(body: Node2D) -> void:
    if body.name == "player":
        body.get_node("Panel").visible = false
        player_in_chat_zone = false


func _on_timer_timeout() -> void:
    $Timer.wait_time = randf_range(1.5, 3.0)
    if current_state == IDLE:
        dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
        current_state = MOVE
    else:
        velocity = Vector2.ZERO
        current_state = IDLE

func _on_dialogic_ended() -> void:
    if Dialogic.timeline_ended.is_connected(_on_dialogic_ended):
        Dialogic.timeline_ended.disconnect(_on_dialogic_ended)
    is_chatting = false
    is_roaming = true

#func move_home(delta):
#	if not house_node:
#		var to_start = start_pos - position
#		if to_start.length() > home_tolerance:
#			dir = to_start.normalized()
#			velocity = dir * speed
#			move_and_slide()
#		else:
#			velocity = Vector2.ZERO
#			current_state = IDLE
#		return


func move_home(delta):
    if home_path.is_empty():
        velocity = Vector2.ZERO
        return

    var current_target = home_path[current_path_index]
    var to_target = current_target.global_position - global_position
    
    if to_target.length() > home_tolerance:
        dir = to_target.normalized()
        velocity = dir * speed
        move_and_slide()
    else:
        # first
        if current_path_index < home_path.size() - 1:
            current_path_index += 1
        else:
            # last point
            velocity = Vector2.ZERO
            current_state = INSIDE_HOUSE
            is_roaming = false 
            print(self.name, " in side the house！")






#	var to_house = house_node.global_position - global_position
    
#	if to_house.length() > home_tolerance:
#		dir = to_house.normalized()
#		velocity = dir * speed
#		move_and_slide()
#	else:
#		velocity = Vector2.ZERO
#		current_state = INSIDE_HOUSE
#		is_roaming = false 
#		print(self.name, " inside house")

#func set_rain_status(raining: bool):
#	is_raining = raining
#	if is_raining:
#		current_state = GO_HOME
#		$Timer.stop()
#	else:
#		is_roaming = true
#		current_state = IDLE
#		$Timer.start(randf_range(1.5, 3.0))

func set_rain_status(raining: bool):
    is_raining = raining
    if is_raining:
        current_path_index = 0
        current_state = GO_HOME
        $Timer.stop()
    else:
        is_roaming = true
        current_state = IDLE
        $Timer.start(randf_range(1.5, 3.0))

func _on_tree_exited() -> void:
    Global.npc_positions[self.name] = self.global_position
    pass # Replace with function body.
