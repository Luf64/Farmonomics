extends Area2D

var item_textures = {
    "Flower_Red": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Red.png"),
    "Flower_Yellow": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Yellow.png"),
    "Flower_Blue": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Blue.png"),
    "Flower_Purple": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Purple.png"),
    "Flower_White": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_White.png"),
}
var flower_type: String = ""
var player_nearby: bool = false

func _ready():
    var flower_types = item_textures.keys()
    var random_flower = flower_types[randi()%flower_types.size()]
    var sprite = $Sprite2D
    sprite.texture = item_textures[random_flower]
    self.flower_type = random_flower

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("interaction") and player_nearby:
        harvest()

func harvest():
    print("Harvested: ", flower_type)
    Json.add_item(flower_type, 1)
    $Sprite2D.visible = false
    if Global.inventory_ui != null:
        Global.inventory_ui.refresh()
    if Global.hotbar_ui != null:
        Global.hotbar_ui.refresh()
    queue_free()

func _on_body_entered(body: Node2D) -> void:
    if body.name == "player":
        body.get_node("Panel2").visible = true
        player_nearby = true

func _on_body_exited(body: Node2D) -> void:
    if body.name == "player":
        body.get_node("Panel2").visible = false
        player_nearby = false
