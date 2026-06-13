extends CanvasLayer

@onready var container = $Control/GridContainer

var item_textures = {
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

}
"""
	"Potion_Red": preload(),
	"Potion_Yellow": preload(),
	"Potion_Blue": preload(),
	"Potion_Purple": preload(),
	"Potion_White": preload()"""

func _ready() -> void:
	var slot = container.get_children()
	for i in slot.size():
		slot[i].slot_number = i
	refresh()

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

func _on_texture_button_pressed():
	Global.inventory_ui.visible = ! Global.inventory_ui.visible
