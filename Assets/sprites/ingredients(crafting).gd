class_name ingredients extends TextureButton

@export var item_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed():
	print("pressed flower")
	var ui = get_tree().get_first_node_in_group("crafting_ui")
	if ui:
		ui.add_item_to_craft(item_name, texture_normal)
