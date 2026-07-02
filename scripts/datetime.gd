extends Control

const DAYS = ["MON","TUE","WED","THU","FRI","SAT","SUN"]

var day_counter = 0:
	set(value):
		day_counter = value
		%day.text = DAYS[day_counter % 7]
		
func next_day():
	day_counter += 1
