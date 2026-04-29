extends Node

const SAVE_FILE = "user://main.json"

var game = {
	"id": "",
	"scene": "res://rooms/room_0.tscn",
	"position": {"x":-575,"y":-317},
	"money": 0,
	"money_state": [],
	"inventory": [],
	"market_price":{
		"Chocolate": 3,
		"Corn": 1,
		"Milk": 3
	}
}

func save_game():
	var player = get_tree().get_first_node_in_group("Player")
	if player != null:
		game.position.x = player.global_position.x
		game.position.y = player.global_position.y
		game.scene = get_tree().current_scene.scene_file_path
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
	if parse != null:
		game = parse
		return true
	return false

func money_change(x):
	game.money +=x
	var change = "+" if x > 0 else ""
	var Track = str(change,x," ","Farmonomies","Total: ", game.money)
	game.money_state.append(Track)
	if game.money_state.size() > 10:
		game.money_state.remove_at(0)
