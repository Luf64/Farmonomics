extends CanvasLayer
 
var period_images: Dictionary = {}
 
 
func _ready() -> void:
	period_images = {
		"midnight": $midnight,
		"morning": $morning,
		"afternoon": $afternoon,
		"night": $night,
	}
 
	Timemanager.period_changed.connect(_on_period_changed)
	_refresh()
 
 
func _process(_delta: float) -> void:
	# Keeps the clock label ticking smoothly between period changes.
	_update_labels()
 
 
func _on_period_changed(_period_name: String) -> void:
	_refresh()
 
 
func _refresh() -> void:
	_update_visuals()
	_update_labels()
 
 
func _update_visuals() -> void:
	var current_period: String = Timemanager.get_current_period()
 
	for period_name in period_images.keys():
		var node = period_images[period_name]
		if node:
			node.visible = (period_name == current_period)
 
 
func _update_labels() -> void:
	if has_node("time"):
		$time.text = Timemanager.get_clock_time_string()
	if has_node("day"):
		$day.text = Timemanager.get_weekday_string()
