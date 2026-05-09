extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.money_changed.connect(_on_money_changed)
	_on_money_changed(Global.money)
	pass # Replace with function body.

func _on_money_changed(new_amount):
	text = str(new_amount)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
