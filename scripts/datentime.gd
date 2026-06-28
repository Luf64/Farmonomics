extends CanvasLayer

@export var DAY_DURATION_SECS: float = 300.0   #real-world seconds equal one day in the game
@export var start_minutes: float = 6.0 * 60.0  # Game start time (default 6:00 AM)

var total_minutes: float
var current_day_index: int = 0 
var days_of_week = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
var current_state = "" # "day" or "night"

@onready var time_label = %time
@onready var day_label = %day
@onready var anim_player = $AnimationPlayer

@onready var period_images = {
	"midnight": $midnight,   # 0:00 - 6:00
	"morning": $morning,     # 6:00 - 12:00
	"afternoon": $afternoon, # 12:00 - 18:00
	"night": $night          # 18:00 - 24:00
}

func _ready() -> void:
	add_to_group("TimeSystem")
	if Global.time != null and not Global.time.is_empty():
		total_minutes = Global.time.get("total_minutes", start_minutes)
		current_day_index = Global.time.get("current_day_index", 0)
	else:
		total_minutes = start_minutes
		current_day_index = 0
	
	# Initialize the check for day/night status.
	var hour = _get_current_hour()
	if hour >= 6 and hour < 18:
		current_state = "day"
	else:
		current_state = "night"
		
	# Initial interface update
	_update_time_system(0.0)

func _process(delta: float) -> void:
	_update_time_system(delta)

## Core Clock and Performance Update System
func _update_time_system(delta: float) -> void:
	# 1. Cumulative time (1,440 minutes per day)
	var minutes_per_second = 1440.0 / DAY_DURATION_SECS
	total_minutes += minutes_per_second * delta
	
	while total_minutes >= 1440.0:
		total_minutes -= 1440.0
		current_day_index = (current_day_index + 1) % 7
		
	# 2.Get the current hour and minute.
	var hour = _get_current_hour()
	var minute = int(int(total_minutes) % 60)
	
	# 3. Update UI text
	time_label.text = "%02d:%02d" % [hour, minute]
	day_label.text = days_of_week[current_day_index]
	
	# 4. Display images for the update period
	_update_images(hour)
	
	# 5. Detect and trigger day-night animations.
	_check_state_changes(hour)

func _get_current_hour() -> int:
	return int(total_minutes / 60)

## Control the hiding and showing of images based on the hour.
func _update_images(hour: int) -> void:
	var current_period_key = ""
	if hour >= 0 and hour < 6:
		current_period_key = "midnight"
	elif hour >= 6 and hour < 12:
		current_period_key = "morning"
	elif hour >= 12 and hour < 18:
		current_period_key = "afternoon"
	elif hour >= 18 and hour < 24:
		current_period_key = "night"

	for key in period_images:
		if period_images[key]:
			period_images[key].visible = (key == current_period_key)

## Detect the time and play the daybreak/nightfall animation.
#func _check_state_changes(hour: int) -> void:
	# Daytime is from 6:00 a.m. to 6:00 p.m.
#	if hour >= 6 and hour < 18:
#		if current_state != "day":
#			current_state = "day"
#			if anim_player.has_animation("nighttoday"):
#				anim_player.play("nighttoday")
#	# The remaining time is night.
#	else:
#		if current_state != "night":
#			current_state = "night"
#			if anim_player.has_animation("daytonight"):
#				anim_player.play("daytonight")

func _check_state_changes(hour: int) -> void:
	# Daytime is from 6:00 a.m. to 6:00 p.m.
	if hour >= 6 and hour < 18:
		if current_state != "day":
			current_state = "day"
			if anim_player and anim_player.has_animation("nighttoday"):
				anim_player.play("nighttoday")
			
			# 2. 【核心结合】通知环境滤镜变亮
			get_tree().call_group("DayNightFilter", "change_to_day")
			
	# The remaining time is night.
	else:
		if current_state != "night":
			current_state = "night"
			if anim_player and anim_player.has_animation("daytonight"):
				anim_player.play("daytonight")
				
			get_tree().call_group("DayNightFilter", "change_to_night")







## Save data to the global script when exiting the scene.
func save_time_to_global() -> void:
	# Calculate the index for the current time slot (compatible with your existing data structure).
	var hour = _get_current_hour()
	var period_idx = 0
	if hour >= 6 and hour < 12: period_idx = 0     # morning
	elif hour >= 12 and hour < 18: period_idx = 1   # afternoon
	elif hour >= 18 and hour < 24: period_idx = 2   # night
	else: period_idx = 3                            # midnight
	
	Global.time = {
		"total_minutes": total_minutes,
		"current_day_index": current_day_index,
		"current_period_index": period_idx
	}
	print("Time data has been saved to Global.time")



func player_sleep() -> void:
	var hour = _get_current_hour()
	
	# day to night
	if hour >= 6 and hour < 18:
		total_minutes = 18.0 * 60.0
		print("The player took a nap, and time skipped to the evening. 18:00")
		
	# night to morning
	else:
		total_minutes = 6.0 * 60.0
		# day2 + 1
		current_day_index = (current_day_index + 1) % 7
		print("The player had a long sleep, and time skipped ahead to the next morning. 6:00")
	
	# Force an immediate update of the UI and animations to prevent screen flickering or lag.
	_update_time_system(0.0)
