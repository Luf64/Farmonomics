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
    if Global.npc_positions.has(self.name):
        self.global_position = Global.npc_positions[self.name]
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




func _on_tree_exited() -> void:
    Global.npc_positions[self.name] = self.global_position
    pass # Replace with function body.
