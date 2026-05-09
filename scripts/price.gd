extends Node

# player money
var money = 100.0

# player bag
var inventory = {
	"Tomato": 5,
	"Corn": 0,
	"Apple":0,
	"Oringe":0,
	"Potato":0
}

# market data
var market_data = {
	"Tomato": {"base_price": 10.0, "stock": 50, "ideal": 50},
	"Corn": {"base_price": 20.0, "stock": 30, "ideal": 30},
	"Appel": {"base_price": 30.0, "stock": 40, "ideal": 40},
	"Oringe": {"base_price": 30.0, "stock": 40, "ideal": 40},
	"Potato": {"base_price": 15.0, "stock": 50, "ideal": 50}
}
