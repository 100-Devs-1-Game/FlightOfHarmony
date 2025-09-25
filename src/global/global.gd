extends Node

const GLIDER_UPGRADES_DIR= "res://shop/upgrades/gliders/"

var glider_upgrades: Array[PonyUpgrade]

signal money_changed(balance: int)

var starting_money: int = 200
var money: int = 0

func _ready() -> void:
	load_upgrades(GLIDER_UPGRADES_DIR, glider_upgrades)
	# TODO
	# same for propulsion and body upgrades ( folders/items don't exist yet )

	#loads money from settings_manager.gd, if there's none sets it to default
	money = int(SettingsManager.get_money(starting_money))
	emit_signal("money_changed")

func load_upgrades(dir: String, arr: Array[PonyUpgrade]):
	for file in ResourceLoader.list_directory(dir):
		# exclude the scenes folder
		if file == "scenes":
			continue
		arr.append(load(dir + "/" + file))

## Adds currency to current amount
func add_currency(amount: int) -> void:
	if amount == 0:
		return
	money = max(0, money + amount)
	emit_signal("money_changed")
	SettingsManager.set_money(money)
	SettingsManager.save_game()

## Overwrites previous currency with new amount
func set_currency(amount: int) -> void:
	money = max(0, amount)
	emit_signal("money_changed")
	SettingsManager.set_money(money)
	SettingsManager.save_game()

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
	emit_signal("money_changed")
	SettingsManager.set_money(money)
	SettingsManager.save_game()
	return true
