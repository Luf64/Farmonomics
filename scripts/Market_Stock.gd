extends Node

const price: float = 1.0
const min_price: float = 0.2
const max_price: float = 2.5
var market_open: bool = true

func _ready() -> void:
	Timemanager.period_changed.connect(on_period_changed)
	market_open = is_open_period(Timemanager.get_current_period())
	if market_open:
		update_all_price()
func on_period_changed(period_name:String) -> void:
	match period_name:
		"morning":
			market_open = true
			refill_all_stock()
			update_all_price()
		"afternoon":
			market_open = true
			update_all_price()
		"night","midnight":
			market_open = false
func is_open_period(period_name: String) -> bool:
	return period_name == "morning" or period_name == "afternoon"

func refill_all_stock() -> void:
	refill_category(Global.crops)
	refill_category(Global.flower)
	refill_category(Global.seed)

func refill_category(category:Dictionary)-> void:
	for item_name in category.keys():
		refill_item(category[item_name])
func refill_item(item:Dictionary) ->void:
	var deficit: int = int(item["ideal"]) - int(item["stock"])
	if deficit <= 0:
		return
	var rarity: int = int(item.get("rarity",1))
	rarity = max(rarity,1)
	var refill_rate: float = 1.0/ float(rarity)
	var refill_amount: int = int(round(deficit*refill_rate))
	item["stock"] = min(int(item["stock"])+ refill_amount, int(item["ideal"]))
	
func update_all_price() -> void:
	update_category_price(Global.crops)
	update_category_price(Global.flower)
	update_category_price(Global.seed)
	Global.global_prices_changed.emit(snapshot())

func update_category_price(category:Dictionary) -> void:
	for item_name in category.keys():
		recalculate_price(category[item_name])

func recalculate_price(item: Dictionary) -> void:
	var stock: float = float(item["stock"])
	var ideal: float = max(float(item["ideal"]),1.0)
	var base_price:float = float(item["base_price"])
	var deviation: float = (ideal - stock)/ideal
	var multiplier: float = 1.0 + price* deviation
	multiplier = clamp(multiplier, min_price, max_price)
	item["current_price"] = base_price* multiplier

func refresh_price(item_name: String) -> void:
	if not market_open:
		return
	var item: Dictionary = find_item(item_name)
	if item.is_empty():
		push_warning("Market_Stock: item not found -> " + item_name)
		return
	recalculate_price(item)
	Global.global_prices_changed.emit(snapshot())
func is_market_open() -> bool:
	return market_open
	
func find_item(item_name: String) -> Dictionary:
	if Global.crops.has(item_name):
		return Global.crops[item_name]
	if Global.flower.has(item_name):
		return Global.flower[item_name]
	if Global.seed.has(item_name):
		return Global.seed[item_name]
	return{}
func snapshot() -> Dictionary:
	return{
		"crops":Global.crops,
		"flower":Global.flower,
		"seed": Global.seed,
		"market_open": market_open
	}
