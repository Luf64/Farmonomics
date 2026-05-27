extends CanvasLayer


@onready var coin_label = $Coin/Label 
@onready var tomato_text = $ScrollContainer/VBoxContainer/Tomato_Button/tomato_price_label2
@onready var corn_text = $ScrollContainer/VBoxContainer/Corn_Button/corn_price_label2
@onready var apple_text = $ScrollContainer/VBoxContainer/Apple_Button/apple_price_label2

# used to temporarily store received market data
var saved_market_data = {}

func init_shop_data(market_data: Dictionary) -> void:
	saved_market_data = market_data
	update_shop_display()

func update_shop_display() -> void:
	if saved_market_data.is_empty():
		return
	if saved_market_data.has("Tomato") and tomato_text:
		var tomato_price = saved_market_data["Tomato"]["current_price"]
		tomato_text.text = "%d" % tomato_price 
	if saved_market_data.has("Corn") and corn_text:
		var corn_price = saved_market_data["Corn"]["current_price"]
		corn_text.text = "%d" % corn_price
	if saved_market_data.has("Apple") and apple_text:
		var apple_price = saved_market_data["Apple"]["current_price"]
		apple_text.text = "%d" % apple_price

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_ui()
	Global.money_changed.connect(func(_new_val): update_ui())

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        close_shop()

func close_shop():
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    queue_free()
    

func _on_tomato_button_pressed():
	var price = 10
	if saved_market_data.has("Tomato"):
		price = saved_market_data["Tomato"]["current_price"]
	if Global.subtract_money(price):
		update_ui()
		add_to_inventory("Tomato")
		saved_market_data["Tomato"]["stock"] -= 1
	else:
		print("Not enought money to buy Tomato")
		
func _on_corn_button_pressed():
	var price = 20
	if saved_market_data.has("Corn"):
		price = saved_market_data["Corn"]["current_price"]
	if Global.subtract_money(price):
		update_ui()
		add_to_inventory("Corn")
		saved_market_data["Corn"]["stock"] -= 1 
	else:
		print("Not enought money to buy Corn")
		
func _on_apple_button_pressed():
	var price = 30 
	if saved_market_data.has("Apple"):
		price = saved_market_data["Apple"]["current_price"]
	if Global.subtract_money(price):
		update_ui()
		add_to_inventory("Apple")
		saved_market_data["Apple"]["stock"] -= 1
	else:
		print("Not enough money to buy Apple")

func update_ui():
    # Update money
    if coin_label:
        coin_label.text = str(Global.money)

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
    


func _on_texture_button_pressed() -> void:
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    queue_free()
    pass # Replace with function body.
