extends CanvasLayer

@onready var money_label = $money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.money_changed.connect(_on_money_changed)
    _update_display(Global.money)
    # monitor scene switching
    get_tree().node_added.connect(_on_scene_changed)
    check_hud_visibility()
    pass # Replace with function body.

# delay the check by one frame to ensure the new scene has fully loaded.
func _on_scene_changed(_node):
    check_hud_visibility.call_deferred()
    
func check_hud_visibility():
    var current_scene = get_tree().current_scene
    if current_scene:
        if current_scene.scene_file_path.contains("room0.1,room_1,room_2,room_3"):
            self.visible = false
        else:
            self.visible = true
            

func _on_money_changed(new_amount):
    _update_display(new_amount)
    
func _update_display(amount):
    if money_label:
        money_label.text = str(amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
