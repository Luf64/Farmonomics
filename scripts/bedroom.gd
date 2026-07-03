extends Node2D

@onready var prompt: Label = $Bedroom/InteractionPrompt
@onready var video_player = $VideoStreamPlayer
var player_in_range: bool = false
var slept_today: bool = false
var video = preload("res://video/blink eye.ogv")

func _ready() -> void:
    # Connect to day_changed signal to reset sleep each new day
    Timemanager.day_changed.connect(_on_day_changed)

func _on_day_changed(_day_number: int) -> void:
    slept_today = false
    if prompt and player_in_range:
        prompt.visible = true

func trigger_sleep() -> void:
    if slept_today:
        print("already slept today")
        return
    if not Timemanager.can_player_sleep():
        print("not tired enough to sleep yet")
        return
    print("sleeping...")
    slept_today = true
    get_tree().call_group("TimeSystem", "player_sleep")
    video_player.visible = true
    video_player.play()
    $Bedroom.visible = false
    if prompt:
        prompt.visible = false

func _process(_delta: float) -> void:
    if player_in_range and Input.is_action_just_pressed("interaction"):
        trigger_sleep()

func _on_area_2d_3_body_entered(body: Node2D) -> void:
    if body.name == "player" or body.is_in_group("player"):
        player_in_range = true
        if prompt and not slept_today:
            prompt.visible = true

func _on_area_2d_3_body_exited(body: Node2D) -> void:
    if body.name == "player" or body.is_in_group("player"):
        player_in_range = false
        if prompt:
            prompt.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "player":
        Json.save_game()
        Global.current_room = "room1"
        Global.coordinates = "Farm"
        get_tree().call_deferred("change_scene_to_file", Global.Room_1)

func _on_video_stream_player_finished() -> void:
    video_player.visible = false
    $Bedroom.visible = true
    if prompt and player_in_range:
        prompt.visible = true
