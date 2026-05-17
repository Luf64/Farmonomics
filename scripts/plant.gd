extends Area2D
@export var corn_textures: Array[Texture2D] = []
@export var chocolate_textures: Array[Texture2D] = []
@export var milk_textures: Array[Texture2D] = []

var grow_time: int = 0
var planted: bool = false
var plant_stage: int = 0
var plant_ID: String = ""
var plants_grow_time: Dictionary = {
    "Corn": 300,
    "Chocolate" : 600,
    "Milk": 500
    
}
# Let 0 == Empty, 1 == Seed, 2 == Growing, 3 == Harvest
func get_current() -> int:
    return Date_Timer.current_time.to_unix()
func plant_seed(id: String): # check ID, plant time
    plant_ID = id
    planted = true
    plant_stage = 1
    grow_time = get_current() + plants_grow_time[plant_ID]
    var x = str (plant_ID + "will grow at" + str(grow_time))
    print(x)
func _process(_delta):
    if planted and plant_stage < 3:
        if get_current()>= grow_time:
            next_stage()
            
func next_stage():
    plant_stage+=1
    if plant_stage == 2:
        grow_time = get_current() + plants_grow_time[plant_ID]
    elif plant_stage == 3:
        planted = false
        print(plant_ID + "is ready to harvest")
func harvest() -> String:
    if plant_stage == 3:
        var id = plant_ID
        reset()
        return id
    return ""
    
func reset():
    plant_stage = 0
    plant_ID = ""
    grow_time = 0
    planted = false
var player: bool = false



func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        player = true

func _on_body_exited(body: Node2D) -> void:
    if body.name == "player":
        player = false
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("f_key"):
        if player:
            if not planted:
                plant_seed("Corn")
            elif plant_stage == 3:
                var item = harvest()
