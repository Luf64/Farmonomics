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
    Global.hotbar_ui.visible =! Global.hotbar_ui.visible
    get_tree().change_scene_to_file(Global.Room_1)
    
func _on_settings_pressed() -> void:
    pass # Replace with function body.
    
func _on_quit_game_pressed() -> void:
    get_tree().quit()


func _on_credits_pressed() -> void:
    get_tree().change_scene_to_file("res://rooms/Credit.tscn")
