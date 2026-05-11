extends CanvasLayer


@onready var coin_label = $Coin/Label 



func _ready():
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
    if Global.subtract_money(price):
        update_ui()
        add_to_inventory("Tomato")
    else:
        print("Not enought money to buy Tomato")
        
func _on_corn_button_pressed():
    var price = 20
    if Global.subtract_money(price):
        update_ui()
        add_to_inventory("Corn") 
    else:
        print("Not enought money to buy Corn")
        
func _on_apple_button_pressed():
    var price = 30 
    if Global.subtract_money(price):
        update_ui()
        add_to_inventory("Apple")
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
