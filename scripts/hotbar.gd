extends CanvasLayer

@onready var container = $Control/GridContainer
var selected_slot: int = 0

var item_textures = {
	"Seed_corn":preload("res://Assets/item/Corn/Seed_corn.png"),
	"Seed_chocolate":preload("res://Assets/item/Chocolate/Seed_chocolate.png"),
	"Seed_milk":preload("res://Assets/item/Milk/Seed_milk.png"),
	
	"Corn": preload("res://Assets/item/Corn/corn(Object).png"),
	"Chocolate": preload("res://Assets/item/Chocolate/chocolate(Object).png"),
	"Milk": preload("res://Assets/item/Milk/milk(Object).png"),
	
	"Apple": preload("res://Assets/item/apple (1).png"),
	"Tomato": preload("res://Assets/item/Tomato.png"),
	"Potato": preload("res://Assets/item/potato.png"),
	"Orange": preload("res://Assets/item/Orange.png"),
	"Flower_Red": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Red.png"),
	"Flower_Yellow": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Yellow.png"),
	"Flower_Blue": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Blue.png"),
	"Flower_Purple": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_Purple.png"),
	"Flower_White": preload("res://Assets/room 4 (brewing room with selling it)/flowers/Flower_White.png"),
	"Potion_Red": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon1.png"),
	"Potion_Yellow": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon2.png"),
	"Potion_Blue": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon9.png"),
	"Potion_Purple": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon15.png"),
	"Potion_White": preload("res://Assets/room 4 (brewing room with selling it)/potion/Transperent/Icon17.png")
}

func _ready() -> void:
	var slot = container.get_children()
	for i in slot.size():
		slot[i].slot_number = i
	select_slot(0)
	refresh()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		select_slot(0)
	elif event.is_action_pressed("2"):
		select_slot(1)
	elif event.is_action_pressed("3"):
		select_slot(2)
	elif event.is_action_pressed("4"):
		select_slot(3)
	elif event.is_action_pressed("5"):
		select_slot(4)
		
func select_slot(number:int) -> void:
		var slot = container.get_children()
		slot[selected_slot].get_node("ColorRect").visible = false
		selected_slot = number
		slot[selected_slot].get_node("ColorRect").visible = true
		var inventory = Json.get_inventory()
		if number < inventory.size() and inventory[number].has("id"):
			Global.current_selected_item = inventory[number]["id"]
		else:
			Global.current_selected_item = ""
		return
func refresh() -> void:
	var inventory = Json.get_inventory()
	var slot = container.get_children()
	
	for i in slot.size():
		var icon = slot[i].get_node("Icon")
		var count = slot[i].get_node("Count")
		if inventory.size()>i and inventory[i].has("id"):
			var item_id = inventory[i]["id"]
			count.text = str(int(inventory[i]["amount"]))
			if item_textures.has(item_id):
				icon.texture = item_textures[item_id]
			else:
				icon.texture = null
		else:
			count.text = ""
			icon.texture = null
