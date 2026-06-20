extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func _on_continue_pressed() -> void:
    Json.load_game()
    Global.hotbar_ui.visible =! Global.hotbar_ui.visible
    get_tree().change_scene_to_file(Global.Room_1)
    
var newgame = preload("res://rooms/user_sign_in.tscn")
func _on_new_game_pressed() -> void:
    Json.game["money"] = 100
    Json.game["inventory"] = [
        {},{},{},{},{},
        {},{},{},{},{},
        {},{},{},{},{},
        {},{},{},{},{},
        {},{},{},{},{},
        {},{},{},{},{},
    ]
    Json.game["scene"] = Global.Room_1
    Global.money = 100
    Json.save_game()
    Global.inventory_ui.refresh()
    Global.hotbar_ui.refresh()
    Global.open_popup_room0(newgame)
    Global.hotbar_ui.visible =! Global.hotbar_ui.visible

func _on_settings_pressed() -> void:
    Global.open_popup_room0(Global.setting_room)
    pass # Replace with function body.

func setting_page():
    if not Global.setting_open:
        Global.setting = Global.setting_room.instantiate()
        add_child(Global.setting)
        Global.setting_open = true
    else:
        Global.setting.queue_free()
        Global.setting = null
        Global.setting_open = false
        

var quit_page = preload("res://rooms/quit_game.tscn")

func _on_quit_game_pressed() -> void:
    Global.open_popup_room0(quit_page)

var credits_page = preload("res://rooms/Credit.tscn")

func _on_credits_pressed() -> void:
    Global.open_popup_room0(credits_page)
