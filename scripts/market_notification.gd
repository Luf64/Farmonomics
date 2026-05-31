extends CanvasLayer

@onready var hide_timer: Timer = Timer.new()
@onready var control_node = $Control
@onready var label_node = $Control/Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	add_child(hide_timer)
	hide_timer.wait_time = 3.0
	hide_timer.one_shot = true
	hide_timer.timeout.connect(func(): visible = false)
	
	
	if Global.global_prices_changed.is_connected(_on_global_prices_changed):
		Global.global_prices_changed.disconnect(_on_global_prices_changed)
	Global.global_prices_changed.connect(_on_global_prices_changed)

func _on_global_prices_changed(market_data: Dictionary) -> void:
	

	if control_node:
		control_node.visible = true

		
	if label_node:
		label_node.text = "[ Market Announcement ]\nPrices of core materials\nhave fluctuated!"
		

	visible = true
	hide_timer.start()
