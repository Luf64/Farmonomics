extends Node2D

func save_all_plant() -> void:
    var plant_data = {}
    for plant in get_tree().get_nodes_in_group("plant"):
        plant_data[plant.name] = {
            "seed_ID": plant.seed_ID,
            "stage":plant.stage
        }
    Json.save_plant(plant_data)

    
func _ready()->void:
    var area = get_node("Area2D")
    for child in area.get_children():
        if child is Area2D and child.get_script() != null:
            child.add_to_group("plant")
    call_deferred("restore_plant")

func restore_plant() -> void:
    var plant_data = Json.load_plant()
    print("Loaded plant data: ", plant_data)
    for plant in get_tree().get_nodes_in_group("plant"):
        print("Restoring: ", plant.name)
        if plant_data.has(plant.name):
            var data = plant_data[plant.name]
            plant.restore(data["seed_ID"], data["stage"])
