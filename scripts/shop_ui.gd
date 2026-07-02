extends CanvasLayer

@onready var buy_sound = $BuySound
@onready var coin_label = $Coin/Label 
@onready var tomato_text = $ScrollContainer/VBoxContainer/Tomato_Button/tomato_price_label2
@onready var corn_text = $ScrollContainer/VBoxContainer/Corn_Button/corn_price_label2
@onready var orange_text = $ScrollContainer/VBoxContainer/Orange_Button/orange_price_label2
@onready var milk_text = $ScrollContainer/VBoxContainer/Milk_Button/milk_price_label2
@onready var chocolate_text = $ScrollContainer/VBoxContainer/Chocolate_Button2/chocolate_price_label2
@onready var flower_red_text = $ScrollContainer/VBoxContainer/Flower_RedButton3/flower_red_price_label2
@onready var corn_stock_text = $ScrollContainer/VBoxContainer/Corn_Button/corn_stock_label
@onready var tomato_stock_text =$ScrollContainer/VBoxContainer/Tomato_Button/tomato_stock_label
@onready var orange_stock_text = $ScrollContainer/VBoxContainer/Orange_Button/orange_stock_label
@onready var milk_stock_text = $ScrollContainer/VBoxContainer/Milk_Button/milk_stock_label
@onready var chocolate_stock_text = $ScrollContainer/VBoxContainer/Chocolate_Button2/chocolate_stock_label
@onready var flower_red_stock_text = $ScrollContainer/VBoxContainer/Flower_RedButton3/flower_red_stock_label
@onready var container = $inventory/GridContainer


# used to temporarily store received market data
func init_shop_data(market_data: Dictionary) -> void:
	update_shop_display()

func update_shop_display() -> void:
	print("Refreshing shop UI")
	print("Orange price:", Global.crops["Orange"]["current_price"])
	if Global.crops.is_empty():
		return
		
	var current_money = Global.money
			
	if Global.crops.has("Tomato") and tomato_text:
		var tomato_price = Global.crops["Tomato"]["current_price"]
		tomato_text.text = "%d" % tomato_price 
		tomato_stock_text.text = "%d" % Global.crops["Tomato"]["stock"]
		if current_money < tomato_price:
			tomato_text.modulate = Color.RED
		else:
			tomato_text.modulate = Color.WHITE
		$ScrollContainer/VBoxContainer/Tomato_Button.disabled = Global.crops["Tomato"]["stock"] <= 0

	if Global.crops.has("Seed_corn") and corn_text:
		var corn_price = Global.crops["Seed_corn"]["current_price"]
		corn_text.text = "%d" % corn_price
		corn_stock_text.text = "%d" % Global.crops["Seed_corn"]["stock"]
		if current_money < corn_price:
			corn_text.modulate = Color.RED
		else:
			corn_text.modulate = Color.WHITE
		$ScrollContainer/VBoxContainer/Corn_Button.disabled = Global.crops["Seed_corn"]["stock"] <= 0
			
	if Global.crops.has("Orange") and orange_text:
		var orange_price = Global.crops["Orange"]["current_price"]
		orange_text.text = "%d" % orange_price
		orange_stock_text.text = "%d" % Global.crops["Orange"]["stock"]
		if current_money < orange_price:
			orange_text.modulate = Color.RED
		else:
			orange_text.modulate = Color.WHITE
		$ScrollContainer/VBoxContainer/Orange_Button.disabled = Global.crops["Orange"]["stock"] <= 0
	
	if Global.crops.has("Seed_milk") and milk_text:
		var milk_price = Global.crops["Seed_milk"]["current_price"]
		milk_text.text = "%d" % milk_price
		milk_stock_text.text = "%d" % Global.crops["Seed_milk"]["stock"]
		if current_money < milk_price:
			milk_text.modulate = Color.RED
		else:
			milk_text.modulate = Color.WHITE
		$ScrollContainer/VBoxContainer/Milk_Button.disabled = Global.crops["Seed_milk"]["stock"] <= 0
			
	if Global.crops.has("Seed_chocolate") and chocolate_text:
		var chocolate_price = Global.crops["Seed_chocolate"]["current_price"]
		chocolate_text.text = "%d" % chocolate_price
		chocolate_stock_text.text = "%d" % Global.crops["Seed_chocolate"]["stock"]
		if current_money < chocolate_price:
			chocolate_text.modulate = Color.RED
		else:
			chocolate_text.modulate = Color.WHITE
		$ScrollContainer/VBoxContainer/Chocolate_Button2.disabled = Global.crops["Seed_chocolate"]["stock"] <= 0
			
	if Global.flower.has("Flower_Red") and flower_red_text:
		var flower_red_price = Global.flower["Flower_Red"]["current_price"]
		flower_red_text.text = "%d" % flower_red_price
		flower_red_stock_text.text = "%d" % Global.flower["Flower_Red"]["stock"]
		if current_money < flower_red_price:
			flower_red_text.modulate = Color.RED
		else:
			flower_red_text.modulate = Color.WHITE
		$ScrollContainer/VBoxContainer/Flower_RedButton3.disabled = Global.flower["Flower_Red"]["stock"] <= 0

func _ready():
	var slot = container.get_children()
	for i in slot.size():
		slot[i].slot_number = i
	refresh()
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_ui()
	Global.money_changed.connect(func(_new_val): 
		update_ui()
		update_shop_display())


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_shop()

func close_shop():
	get_tree().paused = false
	queue_free()
	

func _on_tomato_button_pressed():
	var price = Global.crops["Tomato"]["current_price"]
	if Global.subtract_money(price):
		if buy_sound:
			buy_sound.play()
		update_ui()
		add_to_inventory("Tomato")
		Global.crops["Tomato"]["stock"] -= 1
		MarketStock.refresh_price("Tomato")
		update_shop_display()
		Global.inventory_ui.refresh()
		refresh()
		Global.hotbar_ui.refresh()
	else:
		print("Not enough money to buy Tomato")

func _on_corn_button_pressed():
	var price = Global.crops["Seed_corn"]["current_price"]
	if Global.subtract_money(price):
		if buy_sound:
			buy_sound.play()
		update_ui()
		add_to_inventory("Seed_corn")
		Global.crops["Seed_corn"]["stock"] -= 1 
		MarketStock.refresh_price("Seed_corn")
		update_shop_display()
		Global.inventory_ui.refresh()
		refresh()
		Global.hotbar_ui.refresh()
	else:
		print("Not enought money to buy Corn")
		
func _on_orange_button_pressed():
	var price = Global.crops["Orange"]["current_price"]
	if Global.subtract_money(price):
		if buy_sound:
			buy_sound.play()
		update_ui()
		add_to_inventory("Orange")
		Global.crops["Orange"]["stock"] -= 1
		MarketStock.refresh_price("Orange")
		update_shop_display()
		Global.inventory_ui.refresh()
		refresh()
		Global.hotbar_ui.refresh()
	else:
		print("Not enough money to buy Orange")

func _on_milk_button_pressed() -> void:
	var price = Global.crops["Seed_milk"]["current_price"]
	if Global.subtract_money(price):
		if buy_sound:
			buy_sound.play()
		update_ui()
		add_to_inventory("Seed_milk")
		Global.crops["Seed_milk"]["stock"] -= 1
		MarketStock.refresh_price("Seed_milk")
		update_shop_display()
		Global.inventory_ui.refresh()
		refresh()
		Global.hotbar_ui.refresh()
	else:
		print("Not enough money to buy Milk")


func _on_chocolate_button_2_pressed() -> void:
	var price = Global.crops["Seed_chocolate"]["current_price"]
	if Global.subtract_money(price):
		if buy_sound:
			buy_sound.play()
		update_ui()
		add_to_inventory("Seed_chocolate")
		Global.crops["Seed_chocolate"]["stock"] -= 1
		MarketStock.refresh_price("Seed_chocolate")
		update_shop_display()
		Global.inventory_ui.refresh()
		refresh()
		Global.hotbar_ui.refresh()
	else:
		print("Not enough money to buy Chocolate")

func _on_flower_red_button_3_pressed() -> void:
	var price = Global.flower["Flower_Red"]["current_price"]
	if Global.subtract_money(price):
		if buy_sound:
			buy_sound.play()
		update_ui()
		add_to_inventory("Flower_Red")
		Global.flower["Flower_Red"]["stock"] -= 1
		MarketStock.refresh_price("Flower_Red")
		update_shop_display()
		Global.inventory_ui.refresh()
		refresh()
		Global.hotbar_ui.refresh()
	else:
		print("Not enough money to buy Flower Red")
func update_ui():
	# Update money
	if coin_label:
		coin_label.text = str(Global.money)

func add_to_inventory(item_name):
	Json.add_item(item_name,1)
	print("Bought: ", item_name)

func _on_button_pressed() -> void:
	pass # Replace with function body.
	
func _on_up_button_pressed():
	$VSlider.value -= 1 

func _on_down_button_pressed():
	$VSlider.value += 1

func _on_button_2_pressed() -> void:
	pass # Replace with function body.


var scroll_speed = 20 


func _on_v_box_container_mouse_entered() -> void:
	pass # Replace with function body.
	


func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	queue_free()
	pass # Replace with function body.

var item_textures = {
	
	"Seed_corn":preload("res://Assets/item/Corn/Seed_corn.png"),
	"Seed_chocolate":preload("res://Assets/item/Chocolate/Seed_chocolate.png"),
	"Seed_milk":preload("res://Assets/item/Milk/Seed_milk.png"),

	"Corn": preload("res://Assets/item/Corn/corn(Object).png"),
	"Chocolate": preload("res://Assets/item/Chocolate/chocolate(Object).png"),
	"Milk": preload("res://Assets/item/Milk/milk(Object).png"),
	"Tomato": preload("res://Assets/item/Tomato.png"),
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
