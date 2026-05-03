extends Node

var current_time: Date_Time = Date_Time.new()
var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var system = Time.get_datetime_dict_from_system()
    current_time.year = system["year"]
    current_time.month = system["month"]
    current_time.day = system["day"]
    current_time.hour = system["hour"]
    current_time.minute = system["minute"]
    current_time.second = system["second"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    timer +=delta
    if timer>=1.0:
        timer = 0.0
        current_time.from_unix(current_time.to_unix() + 1)
