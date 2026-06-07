extends Node

const SAVE_FILE = "res://scripts/main.json"

var game = {
	"id": "",
	"scene": "res://rooms/room_0.tscn",
	"position": {"x":0,"y":0},
	"money": 100,
	"money_state": [],
	"inventory": [],
	"market_price":{
		"Chocolate": 3,
		"Corn": 1,
		"Milk": 3
	}
}

func add_item(item:String, amount:int = 1) -> void:
	for entry in game.inventory:
		if entry["id"] == item:
			entry["amount"] += amount
			save_game()
			return
	game.inventory.append({"id":item,"amount":amount})
	save_game()

func remove_item(item:String,amount:int=1) ->void:
	for entry in game.inventory:
		if entry["id"] == item:
			entry["amount"]-=amount
			if entry["amount"] <=0:
				game.inventory.erase(entry)
			save_game()
			return

func get_item_count(item:String) -> int:
	for entry in game.inventory:
		if entry["id"] == item:
			return  entry["amount"]
	return 0

func save_game():
	var player = get_tree().get_first_node_in_group("Player")
	if player != null:
		game.position.x = player.global_position.x
		game.position.y = player.global_position.y
	game.scene = get_tree().current_scene.scene_file_path
	game.money = Global.money
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var content = JSON.stringify(game)
	file.store_string(content)
	file.close()
	print("Game Saved")

func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		print("File could not be found.")
		return false
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var parse = JSON.parse_string(content)
	if parse == null:
		print("Save file corrupted")
		return false
	game = parse
	if not game.has("inventory"):
		game["inventory"] = []
	if not game.has("money"):
		game["money"] = 100
	if not game.has("market_price"):
		game["market_price"] = {"Chocolate":3,"Corn":1,"Milk":3}
	if game.has("money"):
		Global.money = int(game["money"])
	if game.has("scene"):
		print("Loaded scene:",game["scene"])
	if game.has("position"):
		print("Loaded position:",game["position"])
	print("Game loaded sucessfully")
	return true

func apply_save():
	var player = get_tree().get_first_node_in_group("Player")
	if player != null:
		player.global_position = Vector2(game.position.x,game.position.y)
	if player != null:
		player.global_position = Vector2(game.position.x,game.position.y)

func money_change(x: int):
	Global.money += x
	game.money = Global.money
	var sign = "+" if x > 0 else ""
	var track = str(sign,x," ","Farmonomies","Total: ", game.money)
	game.money_state.append(track)
	if game.money_state.size() > 10:
		game.money_state.remove_at(0)

func get_inventory() -> Array:
	return game.inventory
