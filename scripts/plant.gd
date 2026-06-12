extends Area2D

var planted: bool = false
var plant_stage: int = 0
var plant_ID: String = ""
var player: bool = false
var plant_unix_end: int = 0
var is_animating: bool = false


func get_state() -> Dictionary:
	return {
		"node_name": name,
		"plant_ID": plant_ID,
		"plant_stage": plant_stage,
		"plant_unix_end": plant_unix_end,
		"planted": planted
	}

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			child.stop()
			child.frame = 0
			child.visible = false

func get_sprite_for(id: String) -> AnimatedSprite2D:
	for child in get_children():
		if child is AnimatedSprite2D and child.name == id:
			return child
	return null

func interact():
	var x: String = Global.current_selected_item
	if x == "":
		print("No seed selected!")
		return
	if Json.get_item_count(x) <= 0:
		print("You don't have any ", x, " seeds!")
		return
	var sprite = get_sprite_for(x)
	if sprite == null:
		print("No sprite found for: ", x)
		return
	is_animating = true
	sprite.stop()
	sprite.frame = 0
	sprite.visible = true
	sprite.play(x)
	Json.remove_item(x, 1)
	#test
	var anim_length = float(sprite.sprite_frames.get_frame_count(x)) / float(sprite.sprite_frames.get_animation_speed(x))
	await get_tree().create_timer(anim_length).timeout

	# animation stay on last frame after done playing
	sprite.stop()
	#test
	sprite.frame = sprite.sprite_frames.get_frame_count(x) - 1
	sprite.visible = true
	plant_ID = x
	planted = true
	plant_stage = 2
	is_animating = false
	if not Global.crops.has(x):
		print("Crop not found in Global.crops: ", x)
		return
	else:
		var grow_time = Global.crops[x]["grow_time"]
		print(x, " planted! Growing for ", grow_time, " seconds...")
		await get_tree().create_timer(grow_time).timeout
		plant_stage = 3
		print(plant_ID, " is ready! Press F to collect.")

func collect():
	var sprite = get_sprite_for(plant_ID)
	if sprite:
		sprite.stop()
		sprite.visible = false
	Json.add_item(plant_ID, 1)
	print("Collected: ", plant_ID, " → added to inventory")
	print("Inventory: ", Json.game.inventory)
	plant_ID = ""
	planted = false
	plant_stage = 0
	is_animating = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction") and player and not is_animating:
		if not planted:
			interact()
		elif plant_stage == 3:
			collect()
		elif plant_stage == 2:
			print("Still growing...")
		get_viewport().set_input_as_handled()



func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.get_node("Panel").visible = true
		player = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		body.get_node("Panel").visible = false
		player = false

func load_state(data: Dictionary):
	plant_ID = data.get("plant_ID", "")
	plant_stage = data.get("plant_stage", 0)
	plant_unix_end = data.get("plant_unix_end", 0)
	planted = data.get("planted", false)
	for child in get_children():
		if child is AnimatedSprite2D:
			child.stop()
			child.visible = false
	if planted:
		var sprite = get_sprite_for(plant_ID)
		if sprite:
			sprite.frame = sprite.sprite_frames.get_frame_count(plant_ID) - 1
			sprite.visible = true
