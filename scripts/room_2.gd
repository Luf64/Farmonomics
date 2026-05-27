class_name room_2 extends Node


var player_in_range = false
@export var shop_scene: PackedScene
var current_shop = null

@onready var price_system = $PriceSystem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop_UI/interaction.visible = false
	pass # Replace with function body.
	
func _on_market_prices_changed():
	#if the player currently has the shop interface open, immediately refresh the data for them.
	if current_shop != null and current_shop.has_method("init_shop_data"):
		current_shop.init_shop_data($PriceSystem.market_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interaction"):
		if current_shop == null:
			open_shop()
		



func open_shop():
	current_shop = shop_scene.instantiate()
	add_child(current_shop)
	if price_system.prices_changed.is_connected(current_shop.init_shop_data):
		price_system.prices_changed.disconnect(current_shop.init_shop_data)
		price_system.prices_changed.connect(current_shop.init_shop_data.bind(price_system.market_data))
	
	if current_shop.has_method("init_shop_data"):
		current_shop.init_shop_data(price_system.market_data)
	$Shop_UI/PopSound.play()
	$Shop_UI/ShopMenu.visible = true
	$Shop_UI/interaction.visible = false
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_shop_ui_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		$Shop_UI/interaction.visible = true
		
func _on_shop_ui_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		$Shop_UI/interaction.visible = false

func _input(event):
	if $Shop_UI/ShopMenu.visible and event.is_action_pressed("ui_cancel"):
		close_shop()
		
func close_shop():
	$Shop_UI/ShopMenu.visible = false
	get_tree().paused = false
	if current_shop != null:
		current_shop.queue_free()
		current_shop = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.current_room = "room2"
		get_tree().change_scene_to_file(Global.Room_1)
	pass # Replace with function body.
