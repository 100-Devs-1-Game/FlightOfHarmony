extends Node

signal money_changed(balance: int)

const GLIDER_UPGRADES_DIR= "res://shop/upgrades/gliders/"
const PROPULSION_UPGRADES_DIR= "res://shop/upgrades/propulsion/"
const BODY_UPGRADES_DIR= "res://shop/upgrades/body/"
const MONEY_UPGRADES_DIR= "res://shop/upgrades/money/"

var glider_upgrades: Array[ShopUpgrade]
var propulsion_upgrades: Array[ShopUpgrade]
var body_upgrades: Array[ShopUpgrade]
var money_upgrades: Array[ShopUpgrade]

var starting_money: int = 22200
var money: int = 0



func _ready() -> void:
	load_upgrades(GLIDER_UPGRADES_DIR, glider_upgrades)
	load_upgrades(PROPULSION_UPGRADES_DIR, propulsion_upgrades)
	load_upgrades(BODY_UPGRADES_DIR, body_upgrades)
	load_upgrades(MONEY_UPGRADES_DIR, money_upgrades)


func load_upgrades(dir: String, arr: Array[ShopUpgrade]) -> void:
	for file in ResourceLoader.list_directory(dir):
		if not file.ends_with("tres"):
			continue
		arr.append(load(dir + file))
	arr.sort_custom(func(a: ShopUpgrade, b: ShopUpgrade):
		return a.cost < b.cost )


## Adds currency to current amount
func add_currency(amount: int) -> void:
	if amount == 0:
		return
	money = max(0, money + amount)
	money_changed.emit()
	SaveManager.save_game()


## Overwrites previous currency with new amount
func set_currency(amount: int) -> void:
	money = max(0, amount)
	money_changed.emit()
	SaveManager.save_game()


## Checks if theres enough money to buy it
func can_afford(cost: int) -> bool:
	return money >= cost


## Tries to buy it, whatever it would be
func try_spend(cost: int) -> bool:
	if cost <= 0:
		return true
	if money < cost:
		print("Insufficient money to buy upgrade")
		return false
	money -= cost
	money_changed.emit()
	SaveManager.save_game()

	return true


func get_category_upgrades(category: ShopUpgrade.Category)-> Array[ShopUpgrade]:
	match category:
		ShopUpgrade.Category.GLIDER:
			return glider_upgrades
		ShopUpgrade.Category.PROPULSION:
			return propulsion_upgrades
		ShopUpgrade.Category.BODY:
			return body_upgrades
		ShopUpgrade.Category.MONEY:
			return money_upgrades

	return []
