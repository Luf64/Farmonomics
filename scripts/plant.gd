extends Area2D

@export var seed_ID: String = ""
var stage: int = 0
#0 = empty
#1 = animation to frame 1
#2 = animation to frame 2
#3 = ready to harvest

var player_nearby:bool = false
var running_animation:bool = false

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			child.stop()
			child.frame = 0
			

func get_sprite(id:String) -> AnimatedSprite2D:
	for child in get_children():
		if child is AnimatedSprite2D and child.name == id:
			return child
	return null

func plant() -> void:
	var selected = Global.current_selected_item
	if selected == "" or not Global.seed_to_product.has(selected):
		return
	if Json.get_item_count(selected) <= 0:
		return
	var crop_name = Global.seed_to_product[selected]  # "Corn"
	var sprite = get_sprite(crop_name)
	if sprite == null:
		return
	self.seed_ID = selected
	Json.remove_item(selected,1)
	if Global.inventory_ui != null:
		Global.inventory_ui.refresh()
	if Global.hotbar_ui != null:
		Global.hotbar_ui.refresh()
	var grow_time = Global.grow_time.get(seed_ID,10)
	var time_per_frame = grow_time/3

	running_animation = true
	sprite.visible = true
	
	stage = 1
	sprite.frame = 0
	await get_tree().create_timer(time_per_frame).timeout
	
	stage = 2
	sprite.frame = 1
	await get_tree().create_timer(time_per_frame).timeout
	
	stage = 3
	sprite.frame = 2
	running_animation = false
func harvest() -> void:
	var crop_name = Global.seed_to_product.get(seed_ID,seed_ID)
	var sprite = get_sprite(crop_name)
	if sprite != null:
		sprite.stop()
		sprite.frame = 0
		sprite.visible = false
	var product = Global.seed_to_product.get(seed_ID,seed_ID)
	Json.add_item(product,1)
	if Global.inventory_ui != null:
		Global.inventory_ui.refresh()
	if Global.hotbar_ui != null:
		Global.hotbar_ui.refresh()
	stage = 0
	seed_ID = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction") and player_nearby and not running_animation:
		if stage == 0:
			plant()
		elif stage == 3:
			harvest()
		elif stage == 1 or stage == 2:
			print("Still growing")

func _on_body_entered(body:Node2D) -> void:
	if body.name == "player":
		if body.get_node("Panel").visible == false:
			body.get_node("Panel").visible = true
		player_nearby = true
func _on_body_exited(body:Node2D) -> void:
	if body.name == "player":
		body.get_node("Panel").visible = false
		player_nearby = false
