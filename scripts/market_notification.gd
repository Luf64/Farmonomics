extends CanvasLayer

@onready var hide_timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	add_child(hide_timer)
	hide_timer.wait_time = 3.0 # 通知显示 3 秒钟
	hide_timer.one_shot = true
	hide_timer.timeout.connect(func(): visible = false) 
	pass # Replace with function body.

func show_notification() -> void:
	visible = true # 显示 UI
	hide_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
