extends Node

const SAVE_FILE = "user://main.json"

var users: Dictionary = {}

func _ready():
	load_user()
	
func load_user() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		users = {}
		return
		
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		print("Failed to open file.")
		return

	var content = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(content)
	if parsed == null:
		print("Failed to parse JSON.") #Check if file is empty or contains invalid JSON
		users = {}
	else:
		users = parsed

func save_user() -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		print("Failed to open file for writing.")
		return

	file.store_string(JSON.print(users))
	file.close()

func register(username: String) -> Dictionary:
	username = username.strip_edges().to_lower()

	if users.has(username):
		return {"success": false,"username":null, "data":"Username already exists."}

	users[username] = {
		"name": username,
		"coin": 100,
		"market price": {
			"carrot": 5,
			"potato": 5,
			"tomato": 5
		},
		"bag": [""],
		"inventory": [""]
	}
	save_user()
	return {"success": true, "username": username, "data": "User registered successfully."}

func login(username:String) -> Dictionary:
	username = username.strip_edges().to_lower()
	if users.has(username):
		return {"success": true,"username":username,"data":users[username]}
	else:
		return {"success":false, "data": "User not found."}