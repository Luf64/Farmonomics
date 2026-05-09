extends Area2D

@onready var label = $interaction 
var can_interact = false

func _ready():
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	label.hide()

func _on_body_entered(body):
	if body.name == "player":
		can_interact = true
		label.show()

func _on_body_exited(body):
	if body.name == "player":
		can_interact = false
		label.hide()

func _input(event):
	if can_interact and event.is_action_pressed("interact"): 
		open_shop_ui()

func open_shop_ui():
	print("shop")
	
