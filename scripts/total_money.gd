extends CanvasLayer

@onready var money_label = $money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.money_changed.connect(_on_money_changed)
	_update_display(Global.money)
	# monitor scene switching

	pass # Replace with function body.

# delay the check by one frame to ensure the new scene has fully loaded.
	


func _on_money_changed(new_amount):
    _update_display(new_amount)
    
func _update_display(amount):
    if money_label:
        money_label.text = str(amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
