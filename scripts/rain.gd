extends GPUParticles2D

# sec
@export var min_rain_duration: float = 10.0  # Short rain
@export var max_rain_duration: float = 30.0  # Long rain

@export var min_clear_duration: float = 15.0 # Short no rain
@export var max_clear_duration: float = 45.0 # Long no rain

func _ready() -> void:
	# start loop
	weather_loop()

func weather_loop() -> void:
	while true:
		# 1. Rain
		emitting = true
		var rain_time = randf_range(min_rain_duration, max_rain_duration)
		print("Start of rainfall and duration: ", rain_time, " sec")
		await get_tree().create_timer(rain_time).timeout
		
		# 2. Stop rain
		emitting = false
		var clear_time = randf_range(min_clear_duration, max_clear_duration)
		print("The rain has stopped; duration of the clear weather: ", clear_time, " sec")
		await get_tree().create_timer(clear_time).timeout
