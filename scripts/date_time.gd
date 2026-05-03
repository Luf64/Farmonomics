class_name Date_Time
extends RefCounted

var year: int = 2026
var month: int = 1 #1-12
var day: int =1 #1-31
var hour: int= 0#0-23
var second: int = 0 #0-59
var minute: int = 0 # 0-59

# Month and Date structuring in Year Structure 
static func month_days_total(x:int,y:int):
     match x:
        4,6,9,11:   
            return 30
        2: 
            return 29 if is_leap_year(y) else 28
        1,3,5,7,8,10,12:
            return 31
static func is_leap_year(x:int) -> bool:
    return(x % 4 == 0 and x%100 != 0) or (x%400 == 0)
    
static func month_name(x:int):
    const Month_Name:= ["", "January","February","March","April","May","June","July","August","September","October","November","December"]
    return Month_Name[clamp(x,1,12)]

static func week_days_total(x:int):
    const week_days:= ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    return week_days[x%7]

func date():
    var date = "%d %s %d" % [day, month_name(month), year]
    return date

func time():
    var time = "%02d:%02d:%02d" % [hour, minute,second]
    return time

func to_unix() -> int: # 1 Jan 1970
    var dict:={
        "year": year,
        "month": month,
        "day":day,
        "hour":hour,
        "minute": minute,
        "second": second
    }
    return Time.get_unix_time_from_datetime_dict(dict)

func from_unix(unix:int) -> void:
    var dictionary:=Time.get_datetime_dict_from_unix_time(unix)
    year = dictionary["year"]
    month = dictionary["month"]
    day = dictionary["day"]
    hour = dictionary["hour"]
    minute = dictionary["minute"]
    second = dictionary["second"]
