extends CanvasLayer


@onready var coin_label = $Coin/Label 
@onready var tomato_text = $ScrollContainer/VBoxContainer/Tomato_Button/tomato_price_label2
@onready var corn_text = $ScrollContainer/VBoxContainer/Corn_Button/corn_price_label2
@onready var apple_text = $ScrollContainer/VBoxContainer/Apple_Button/apple_price_label2
@onready var orange_text = $ScrollContainer/VBoxContainer/Orange_Button/orange_price_label2
@onready var potato_text = $ScrollContainer/VBoxContainer/Potato_Button/potato_price_label2
@onready var buy_sound = $BuySound

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
        if current_money < tomato_price:
            tomato_text.modulate = Color.RED
        else:
            tomato_text.modulate = Color.WHITE
            
    if Global.crops.has("Corn") and corn_text:
        var corn_price = Global.crops["Corn"]["current_price"]
        corn_text.text = "%d" % corn_price
        if current_money < corn_price:
            corn_text.modulate = Color.RED
        else:
            corn_text.modulate = Color.WHITE
            
    if Global.crops.has("Apple") and apple_text:
        var apple_price = Global.crops["Apple"]["current_price"]
        apple_text.text = "%d" % apple_price
        if current_money < apple_price:
            apple_text.modulate = Color.RED
        else:
            apple_text.modulate = Color.WHITE
            
    if Global.crops.has("Orange") and orange_text:
        var orange_price = Global.crops["Orange"]["current_price"]
        orange_text.text = "%d" % orange_price
        if current_money < orange_price:
            orange_text.modulate = Color.RED
        else:
            orange_text.modulate = Color.WHITE
            
    if Global.crops.has("Potato") and potato_text:
        var potato_price = Global.crops["Potato"]["current_price"]
        potato_text.text = "%d" % potato_price
        if current_money < potato_price:
            potato_text.modulate = Color.RED
        else:
            potato_text.modulate = Color.WHITE

func _ready():
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
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    queue_free()
    

func _on_tomato_button_pressed():
    var price = 10
    if Global.crops.has("Tomato"):
        price = Global.crops["Tomato"]["current_price"]
    if Global.subtract_money(price):
        if buy_sound:
            buy_sound.play()
        update_ui()
        add_to_inventory("Tomato")
        Global.crops["Tomato"]["stock"] -= 1
    else:
        print("Not enought money to buy Tomato")
        
func _on_corn_button_pressed():
    var price = Global.crops["Corn"]["current_price"]
    if Global.subtract_money(price):
        if buy_sound:
            buy_sound.play()
        update_ui()
        add_to_inventory("Corn")
        Global.crops["Corn"]["stock"] -= 1 
    else:
        print("Not enought money to buy Corn")
        
func _on_apple_button_pressed():
    var price = Global.crops["Apple"]["current_price"]
    if Global.subtract_money(price):
        if buy_sound:
            buy_sound.play()
        update_ui()
        add_to_inventory("Apple")
        Global.crops["Apple"]["stock"] -= 1
    else:
        print("Not enough money to buy Apple")
        
func _on_orange_button_pressed():
    var price = Global.crops["Orange"]["current_price"]
    if Global.subtract_money(price):
        if buy_sound:
            buy_sound.play()
        update_ui()
        add_to_inventory("Orange")
        Global.crops["Orange"]["stock"] -= 1
    else:
        print("Not enough money to buy Orange")
        
        
func _on_potato_button_pressed():
    var price = Global.crops["Potato"]["current_price"]
    if Global.subtract_money(price):
        if buy_sound:
            buy_sound.play()
        update_ui()
        add_to_inventory("Potato")
        Global.crops["Potato"]["stock"] -= 1
    else:
        print("Not enough money to buy Potato")

func update_ui():
    # Update money
    if coin_label:
        coin_label.text = str(Global.money)

func add_to_inventory(item_name):
<<<<<<< HEAD
    Json.add_item(item_name,1)
    if Global.inventory_ui != null:
        Global.inventory_ui.refresh()
    if Global.hotbar_ui !=null:
        Global.hotbar_ui.refresh()
    print("Bought: ", item_name)
=======
    print("Buy sussesfully: ", item_name)
>>>>>>> a5ae896606fe9e468ea0edfab089242f9e29fc9f

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
<<<<<<< HEAD
    get_tree().paused = false
    queue_free()
    pass # Replace with function body.
=======
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    queue_free()
    pass # Replace with function body.
>>>>>>> a5ae896606fe9e468ea0edfab089242f9e29fc9f
