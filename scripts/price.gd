extends Node

signal prices_changed

# player money
var money = 100.0

# player bag
var inventory = {
	"Tomato": 0,
	"Corn": 0,
	"Apple":0,
	"Orange":0,
	"Potato":0
}

# market data
var market_data = Global.crops



# --- 【New: Timed Fluctuations】 ---
const UPDATE_INTERVAL: int = 5
var next_update_unix: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for item_name in market_data.keys():
		market_data[item_name]["current_price"] = market_data[item_name]["base_price"]
		
	next_update_unix = Date_Timer.get_current() + UPDATE_INTERVAL
		
func _process(_delta: float) -> void:
	if Date_Timer.get_current() >= next_update_unix:
		update_market_prices()
		next_update_unix = Date_Timer.get_current() + UPDATE_INTERVAL
		
		
func update_market_prices() -> void:
	print("[Market Notify] Time's up! Prices are fluctuating!")
	for item_name in market_data.keys():
		var item = market_data[item_name]
		#basic supply and demand coefficient: If inventory < the ideal value, prices will up; if inventory > ideal value, prices will fall
		var supply_demand_ratio = 1.0 + (float(item["ideal"] - item["stock"]) / float(item["stock"]))
		supply_demand_ratio = clamp(supply_demand_ratio, 0.6, 1.8) #limit the range
		#random market disturbances: In addition to supply and demand, they bring an extra 20% of random fluctuations (sometimes high, sometimes low)
		var random_factor = randf_range(0.8, 1.2)
		#calculate the final price
		var new_price = item["base_price"] * supply_demand_ratio * random_factor
		#ensure the price is at least 1 and rounded to the nearest integer 
		item["current_price"] = int(max(1.0, new_price))
		print("- ", item_name, " The latest price becomes: ", item["current_price"], " (Current inventory: ", item["stock"], ")")

	prices_changed.emit()
	Global.global_prices_changed.emit(market_data)
		
