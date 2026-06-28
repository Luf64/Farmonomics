extends StaticBody2D

var state = "day" #day night
@onready var anim_player = $AnimationPlayer
var change_state = false

#var length_of_day = 600 #sec
#var length_of_night = 300 #sec


#func _ready() -> void:
#	if state == "day":
#		$ColorRect.color.a = 0
#	if state == "night":
#		$ColorRect.color.a = 150

func _ready() -> void:
	# 将自己加入群组，方便全局调用
	add_to_group("DayNightFilter")


#func _on_timer_timeout() -> void:
#	if state == "day":
#		state = "night"
#	elif state == "night":
#		state = "day"
#		
#	change_state = true
	
	
#func _process(delta):
#	if change_state == true:
#		change_state = false
#		if state == "day":
#			change_to_day()
#		elif state == "night":
#			change_to_night()
			
func change_to_day() -> void:
	if anim_player.has_animation("nighttoday"):
		anim_player.play("nighttoday")
		print("Environment Filter: Switching to daytime....")

func change_to_night() -> void:
	if anim_player.has_animation("daytonight"):
		anim_player.play("daytonight")
		print("Environment Filter: Switching to nighttime....")




#func change_to_day():
#	$AnimationPlayer.play("nighttoday")
#	$Timer.wait_time = length_of_day
#	$Timer.start()
	
#func change_to_night():
#	$AnimationPlayer.play("daytonight")
#	$Timer.wait_time = length_of_night
#	$Timer.start()
