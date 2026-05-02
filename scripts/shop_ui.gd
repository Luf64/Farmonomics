extends CanvasLayer


@onready var coin_label = $Coin/Label 

var player_coins = 100 # Start money

func _ready():
	update_ui()

func _on_tomato_button_pressed():
	var price = 10
	if player_coins >= price:
		player_coins -= price
		update_ui()
		add_to_inventory("Tomato")
	else:
		print("Not enought money to buy Tomato")
		
func _on_corn_button_pressed():
	var price = 20
	if player_coins >= price:
		player_coins -= price
		update_ui()
		add_to_inventory("Corn") 
	else:
		print("Not enought money to buy Corn")
		
func _on_apple_button_pressed():
	var price = 30 
	if player_coins >= price:
		player_coins -= price
		update_ui()
		add_to_inventory("Apple")
	else:
		print("Not enought money to buy Apple")

func update_ui():
	# Update money
	if coin_label:
		coin_label.text = str(player_coins)

func add_to_inventory(item_name):
	print("Buy sussesfully: ", item_name)

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
	
