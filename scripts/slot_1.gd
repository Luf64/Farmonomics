extends Panel

@export var slot_number: int = 0
    
func _get_drag_data(at_position:Vector2):
    var inventory = Json.get_inventory()
    if slot_number >= inventory.size() or inventory[slot_number].is_empty():
        return null
    
    var image = TextureRect.new()
    image.texture = $Icon.texture
    image.custom_minimum_size = Vector2(64,64)
    set_drag_preview(image)
    return {"took_slot":slot_number}

func _can_drop_data(at_position: Vector2, data) -> bool:
    return data is Dictionary and data.has("took_slot")
    
func _drop_data(at_position:Vector2, data)->void:
    var take = data["took_slot"]
    var put = slot_number
    
    if take == put:
        return
    var inventory = Json.get_inventory()
    
    while inventory.size() <= take:
        inventory.append({})
    while inventory.size() <= put:
        inventory.append({})
    var hover_image = inventory[take]
    inventory[take] = inventory[put]
    inventory[put] = hover_image
    Json.save_game()
    
    if Global.inventory_ui:
        Global.inventory_ui.refresh()
    if Global.hotbar_ui:
        Global.hotbar_ui.refresh()
