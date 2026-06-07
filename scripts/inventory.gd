extends CanvasLayer

@onready var json = get_node("/root/json")
@onready var container = $Control/GridContainer

func _ready() -> void:
	add_to_group("inventory_ui")
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed():
	Global.open_inventory()

func refresh_inventory():
	container.clear()
	
	var items = json.get_inventory()
	
	for item in items:
		var label = Label.new()
		var text = item["id"] + " x" + str(item["amount"])
		container.add_child(label)
		label.text = text
		container.add_child(label)

func open_inventory():
	refresh_inventory()
	visible = true
