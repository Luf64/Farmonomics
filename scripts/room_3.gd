class_name room_3 extends Node

var player_in_range_npc = false
var player_in_range_tp_room1 = false
var interaction_menu = false

var crafting_ui_open = false
var crafting_ui = null
var crafting_ui_room = preload("res://rooms/crafting_ui.tscn")

var selling_ui_open = false
var selling_ui = null
var selling_ui_room = preload("res://rooms/shop_ui_room3.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    if player_in_range_npc and Input.is_action_just_pressed("interaction"):
        open_menu()
    
    if player_in_range_tp_room1 and Input.is_action_just_pressed("interaction"):
        Global.current_room = "room3"
        get_tree().change_scene_to_file(Global.Room_1)
    
    if interaction_menu and Input.is_action_just_pressed("1"):
        selling_ui_toggle()
    
    if interaction_menu and Input.is_action_just_pressed("2"):
        crafting_ui_toggle()
    
    pass


func _on_tp_to_room_1_body_entered(body: Node2D) -> void:
    if body.name == "player":
        player_in_range_tp_room1 = true
        $"tp to room 1/Panel".visible = true
    pass 

func _on_tp_to_room_1_body_exited(body: Node2D) -> void:
    if body.name == "player":
        player_in_range_tp_room1 = false
        $"tp to room 1/Panel".visible = false
    pass # Replace with function body.

func _on_npc_body_entered(body: Node2D) -> void:
    if body.name == "player":
        player_in_range_npc = true
        $npc/press_f.visible = true
    

func _on_npc_body_exited(body: Node2D) -> void:
    if body.name == "player":
        player_in_range_npc = false
        $npc/press_f.visible = false
        $npc/options.visible = false

func open_menu():
    interaction_menu = true
    $npc/press_f.visible = false
    $npc/options.visible = true

func crafting_ui_toggle():
    if not crafting_ui_open:
        crafting_ui = crafting_ui_room.instantiate()
        call_deferred("add_child", crafting_ui)
        crafting_ui_open = true
    else:
        crafting_ui.queue_free()
        crafting_ui = null
        crafting_ui_open = false

func selling_ui_toggle():
    if not selling_ui_open:
        selling_ui = selling_ui_room.instantiate()
        call_deferred("add_child", selling_ui)
        selling_ui_open = true
    else:
        selling_ui.queue_free()
        selling_ui = null
        selling_ui_open = false
