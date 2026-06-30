extends Node
 
 
signal period_changed(period_name: String)
signal day_changed(day_number: int)
 
const PERIOD_DURATION: float = 5.0 * 60.0  # 5 minutes in seconds
const PERIODS: Array[String] = ["midnight", "morning", "afternoon", "night"]
 
const PERIOD_HOUR_RANGE := {
	"midnight": [0, 6],
	"morning": [6, 12],
	"afternoon": [12, 18],
	"night": [18, 24],
}
 
const WEEKDAYS: Array[String] = [
	"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
]
 
 
func _ready() -> void:
	load_time_from_global()
	add_to_group("TimeSystem")
 
 
func _process(delta: float) -> void:
	if not Global.time.has("time_in_period"):
		load_time_from_global()
		return
 
	Global.time["time_in_period"] += delta
 
	if Global.time["time_in_period"] >= PERIOD_DURATION:
		Global.time["time_in_period"] -= PERIOD_DURATION
		_advance_period()
 
 
func _advance_period() -> void:
	Global.time["period_index"] = (int(Global.time["period_index"]) + 1) % PERIODS.size()
 
	if Global.time["period_index"] == 0:
		Global.time["day"] = int(Global.time["day"]) + 1
		day_changed.emit(Global.time["day"])
 
	period_changed.emit(get_current_period())
 
 
func get_current_period() -> String:
	return PERIODS[int(Global.time["period_index"])]
 
 
func get_period_progress() -> float:
	return float(Global.time["time_in_period"]) / PERIOD_DURATION
 
 
func get_clock_time_string() -> String:
	var range = PERIOD_HOUR_RANGE[get_current_period()]
	var start_hour: float = range[0]
	var end_hour: float = range[1]
 
	var progress: float = get_period_progress()
	var current_hour_float: float = lerp(start_hour, end_hour, progress)
 
	var hour: int = int(current_hour_float)
	var minute: int = int((current_hour_float - hour) * 60.0)
 
	return "%02d:%02d" % [hour, minute]
 
 
func get_weekday_string() -> String:
	var index: int = (int(Global.time["day"]) - 1) % WEEKDAYS.size()
	return WEEKDAYS[index]
 
 
# Call after Global.time has just been set from a save file
# (e.g. right after Json.load_game()).
func load_time_from_global() -> void:
	if typeof(Global.time) != TYPE_DICTIONARY:
		Global.time = {}
 
	if not Global.time.has("period_index"):
		Global.time["period_index"] = 1  # default: start at "morning" (6:00)
	else:
		Global.time["period_index"] = int(Global.time["period_index"])
 
	if not Global.time.has("time_in_period"):
		Global.time["time_in_period"] = 0.0
	else:
		Global.time["time_in_period"] = float(Global.time["time_in_period"])
 
	if not Global.time.has("day"):
		Global.time["day"] = 1
	else:
		Global.time["day"] = int(Global.time["day"])
 
 
# Called by Json.save_game() right before it writes Global.time to disk.
func save_time_to_global() -> void:
	pass  # state already lives directly in Global.time as we go
 
 
# Optional: jump straight to a specific period (e.g. sleeping/skipping)
func set_period(period_name: String) -> void:
	var index: int = PERIODS.find(period_name)
	if index == -1:
		push_warning("Unknown period: " + period_name)
		return
 
	Global.time["period_index"] = index
	Global.time["time_in_period"] = 0.0
	period_changed.emit(get_current_period())
 
func player_sleep() -> void:
	var period = get_current_period()

	if period == "morning" or period == "afternoon":
		# 白天睡觉 -> 跳到当天晚上 (night, 18:00)
		set_period("night")
		print("The player took a nap, and time skipped to the evening. 18:00")
	else:
		# midnight 或 night 睡觉 -> 跳到第二天早上 (morning, 6:00)
		Global.time["day"] = int(Global.time["day"]) + 1
		set_period("morning")
		day_changed.emit(Global.time["day"])
		print("The player had a long sleep, and time skipped ahead to the next morning. 6:00")
