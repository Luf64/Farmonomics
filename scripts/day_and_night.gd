extends StaticBody2D
var state = "day" #day night
@onready var anim_player = $AnimationPlayer
var change_state = false

func _ready() -> void:
    add_to_group("DayNightFilter")
    $ColorRect.visible = false
    # Sync to whatever period TimeManager is already in (handles scene reloads mid-day)
    _on_period_changed(Timemanager.get_current_period())
    Timemanager.period_changed.connect(_on_period_changed)

func _on_period_changed(period_name: String) -> void:
    match period_name:
        "morning", "afternoon":
            change_to_day()
        "night", "midnight":
            change_to_night()

func change_to_day() -> void:
    if state == "day":
        return
    state = "day"
    if anim_player.has_animation("nighttoday"):
        anim_player.play("nighttoday")
    print("Environment Filter: Switching to daytime....")
    $ColorRect.visible = false

func change_to_night() -> void:
    if state == "night":
        return
    state = "night"
    if anim_player.has_animation("daytonight"):
        anim_player.play("daytonight")
    print("Environment Filter: Switching to nighttime....")
    $ColorRect.visible = true
