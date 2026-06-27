extends Area2D

@export var flower_scene:PackedScene = preload("res://rooms/flower.tscn")
@export var spawn_interval_min: float = 3.0
@export var spawn_interval_max: float = 8.0
@export var flowers_per_spawn: int =3
@export var max_flowers: int = 6

var active_flowers: Array = []
var spawn_timer: float = 0.0
var time_until_next_spawn: float = 0.0

func _ready():
    time_until_next_spawn = randf_range(spawn_interval_min, spawn_interval_max)

func _physics_process(delta:float) -> void:
    for i in range(active_flowers.size()-1,-1,-1):
        if not is_instance_valid(active_flowers[i]):
            active_flowers.remove_at(i)
    spawn_timer += delta
    if spawn_timer >= time_until_next_spawn:
        if active_flowers.size() < max_flowers:
            spawn_flowers()
        spawn_timer = 0.0
        time_until_next_spawn = randf_range(spawn_interval_min, spawn_interval_max)
    
func spawn_flowers() -> void:
    var flowers_to_spawn = min(flowers_per_spawn,max_flowers-active_flowers.size())
    for i in range(flowers_to_spawn):
        var flower = flower_scene.instantiate()
        add_child(flower)
        flower.global_position = get_random_spawn_position()
        active_flowers.append(flower)

func get_random_spawn_position() -> Vector2:
    var collision_shape = $CollisionShape2D
    var shape = collision_shape.shape
    if shape is RectangleShape2D:
        var rectangle = shape.size
        var random_x = randf_range(-rectangle.x/2,rectangle.x/2)
        var random_y = randf_range(-rectangle.y/2,rectangle.y/2)
        return global_position +Vector2(random_x,random_y)
    return global_position


func _on_flower_plant_region_visibility_changed() -> void:
        set_physics_process(visible)
