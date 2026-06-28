extends Node2D

@onready var sprite: Sprite2D = $lift

var player_in_range_tp_room1 = false
var player_in_range_god = false

var cloud_shop_open = false
var cloud_shop_ui = null
var cloud_shop_scene = preload("res://rooms/cloud_shop_ui.tscn")

var frames = [
    preload("res://Assets/lift_1.png"),
    preload("res://Assets/lift_2.png"),
    preload("res://Assets/lift_3.png")
]

func _ready() -> void:
    sprite.texture = frames[0]

func _process(delta: float) -> void:
    if player_in_range_tp_room1 and Input.is_action_just_pressed("interaction"):
        Global.current_room = "sky_shop"
        get_tree().change_scene_to_file(Global.liftdown)
    if player_in_range_god and Input.is_action_just_pressed("interaction"):
        $god/interaction/Label.visible = false
        $god/interaction/choice.visible = true
    if player_in_range_god and Input.is_action_just_pressed("2"):
            cloud_shop_toggle()

func _on_animation_body_entered(body: Node2D) -> void:
    if body.name == "player":
        sprite.texture = frames[0]
        await get_tree().create_timer(1.0).timeout
        sprite.texture = frames[1]
        await get_tree().create_timer(1.0).timeout
        sprite.texture = frames[2]

func _on_animation_body_exited(body: Node2D) -> void:
    if body.name == "player":
        sprite.texture = frames[2]
        await get_tree().create_timer(1.0).timeout
        sprite.texture = frames[1]
        await get_tree().create_timer(1.0).timeout
        sprite.texture = frames[0]


func _on_lift_door_body_entered(body: Node2D) -> void:
    if body.name == "player":
        player_in_range_tp_room1 = true
        $lift/lift_door/Panel.visible = true

func _on_lift_door_body_exited(body: Node2D) -> void:
    if body.name == "player":
        player_in_range_tp_room1 = false
        $lift/lift_door/Panel.visible = false


func _on_interaction_body_entered(body: Node2D) -> void:
    if body.name == "player":
        $god/interaction/Label.visible = true
        player_in_range_god = true


func _on_interaction_body_exited(body: Node2D) -> void:
    if body.name == "player":
        $god/interaction/Label.visible = false
        $god/interaction/choice.visible = false
        player_in_range_god = false


func cloud_shop_toggle():
    if not cloud_shop_open:
        cloud_shop_ui = cloud_shop_scene.instantiate()
        cloud_shop_ui.closed.connect(func(): cloud_shop_open = false; cloud_shop_ui = null)
        call_deferred("add_child", cloud_shop_ui)
        cloud_shop_open = true
    else:
        cloud_shop_ui.queue_free()
        cloud_shop_ui = null
        cloud_shop_open = false


func _on_speech_1_body_entered(body: Node2D) -> void:
    if body.name == "player":
        $god/speech1/Label.visible = true


func _on_speech_1_body_exited(body: Node2D) -> void:
    if body.name == "player":
        $god/speech1/Label.visible = false


func _on_speech_2_body_entered(body: Node2D) -> void:
    if body.name == "player":
        $god/speech2/Label.visible = true


func _on_speech_2_body_exited(body: Node2D) -> void:
    if body.name == "player":
        $god/speech2/Label.visible = false
