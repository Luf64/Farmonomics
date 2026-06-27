extends CanvasLayer

@onready var container = $Control/GridContainer

signal closed

# items that CANNOT be sold (seeds)
const UNSELLABLE = ["Seed_corn", "Seed_chocolate", "Seed_milk"]

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
		slot[i].sell_pressed.connect(_on_slot_sell_pressed)
	refresh()

func refresh() -> void:
	var inventory = Json.get_inventory()
	var slot = container.get_children()

	for i in slot.size():
		var icon = slot[i].get_node("Icon")
		var count = slot[i].get_node("Count")
		if inventory.size() > i and inventory[i].has("id"):
			var item_id = inventory[i]["id"]
			var sellable = not UNSELLABLE.has(item_id)
			count.text = str(int(inventory[i]["amount"]))
			if item_textures.has(item_id):
				icon.texture_normal = item_textures[item_id]
			else:
				icon.texture = null
			slot[i].modulate = Color.WHITE if sellable else Color(1, 1, 1, 0.4)
			slot[i].sellable = sellable
		else:
			count.text = ""
			icon.texture_normal = null
			slot[i].sellable = false

func _on_slot_sell_pressed(slot_number: int) -> void:
	var inventory = Json.get_inventory()
	if slot_number >= inventory.size() or inventory[slot_number].is_empty():
		return

	var item_id = inventory[slot_number]["id"]
	if UNSELLABLE.has(item_id):
		return

	var price = get_sell_price(item_id)
	if price <= 0:
		return

	Json.remove_item(item_id, 1)
	Json.money_change(price)
	refresh()

func get_sell_price(item_id: String) -> int:
	if Global.crops.has(item_id):
		return int(Global.crops[item_id]["current_price"])
	# fallback flat prices for potions/flowers not in Global.crops
	var flat_prices = {
		"Flower_Red": 5, "Flower_Yellow": 5, "Flower_Blue": 5,
		"Flower_Purple": 5, "Flower_White": 5,
		"Potion_Red": 20, "Potion_Yellow": 20, "Potion_Blue": 20,
		"Potion_Purple": 20, "Potion_White": 20
	}
	return flat_prices.get(item_id, 0)

func _on_help_pressed() -> void:
	$Control/help/Panel.visible = true
	await get_tree().create_timer(10.0).timeout
	$Control/help/Panel.visible = false

func _on_close_pressed() -> void:
	closed.emit()
	queue_free()
