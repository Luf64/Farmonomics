extends Node

signal prices_changed

var market_data = Global.crops

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
    for item_name in market_data:
        var item = market_data[item_name]
        var supply_demand_ratio = float(item["ideal"]) / float(max(1, item["stock"]))
        supply_demand_ratio = clamp(supply_demand_ratio, 0.6, 1.8)
        var random_factor = randf_range(0.8, 1.2)
        var new_price = item["base_price"] * supply_demand_ratio * random_factor
        item["current_price"] = int(max(1.0, new_price))
        print("- ", item_name, " The latest price becomes: ", item["current_price"], " (Current inventory: ", item["stock"], ")")
        prices_changed.emit()
        Global.global_prices_changed.emit(market_data)
        prices_changed.emit()
