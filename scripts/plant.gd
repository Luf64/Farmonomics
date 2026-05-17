extends Area2D

var grow_time: int = 0
var planted: bool = false
var plant_stage: int = 0
var plant_ID: String = ""
var player:bool = false
var plants_grow_time: Dictionary = {
    "Corn": 300,
    "Chocolate" : 600,
    "Milk": 500
    
}

# Let 0 == Empty, 1 == Seed, 2 == Growing, 3 == Harvest
func plant_seed(id: String): # check ID, plant time
    plant_ID = id
    planted = true
    plant_stage = 1
    update_sprite()
    var x = str (plant_ID + "will grow at" + str(grow_time))
    print(x)

func update_sprite():
    # find the AnimatedSprite2D regardless of its name
    var sprite: AnimatedSprite2D = null
    for child in get_children():
        if child is AnimatedSprite2D:
            sprite = child
            break
    if sprite == null:
        return
    if plant_stage == 0 or plant_ID == "":
        sprite.visible = false
        return
    sprite.visible = true
    # check the animation exists before playing
    if sprite.sprite_frames.has_animation(plant_ID):
        sprite.play(plant_ID)
        sprite.frame = plant_stage - 1
    else:
        print("Missing animation: ", plant_ID, " in ", name)
    

func get_state() -> Dictionary:
    return{
        "node_name": name,
        "plant_ID": plant_ID,
        "plant_stage": plant_stage,
        "grow_time": grow_time,
        "planted": planted
    }
    
func load_state(data:Dictionary):
    plant_ID = data.get("plant_ID","")
    plant_stage = data.get("plant_stage",0)
    grow_time = data.get("grow_time",0)
    planted = data.get("planted",false)
    update_sprite()

func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        player = true

func _on_body_exited(body: Node2D) -> void:
    if body.name == "player":
        player = false
    
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("interaction"):
        if player and not planted:
            plant_seed("Corn")
