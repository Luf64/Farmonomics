extends Area2D

@onready var sprite = $AnimatedSprite2D

var bob_height = 10.0  
var bob_speed = 3.0    
var time = 0.0         

func _ready():
	sprite.sprite_frames.set_animation_loop("default", true)
	
	sprite.play("default")


func _physics_process(delta):
	time += delta
	
	var offset = sin(time * bob_speed) * bob_height
	

	sprite.offset.y = offset
