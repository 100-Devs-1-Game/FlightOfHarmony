extends Node

const GLIDER_UPGRADES_DIR= "res://shop/upgrades/gliders/"
const PROPULSION_UPGRADES_DIR= "res://shop/upgrades/propulsion/"
const BODY_UPGRADES_DIR= "res://shop/upgrades/body/"

var glider_upgrades: Array[PonyUpgrade]
var propulsion_upgrades: Array[PonyUpgrade]
var body_upgrades: Array[PonyUpgrade]

signal money_changed(balance: int)

var starting_money: int = 22200
var money: int = 0

func _ready() -> void:
	load_upgrades(GLIDER_UPGRADES_DIR, glider_upgrades)
	load_upgrades(PROPULSION_UPGRADES_DIR, propulsion_upgrades)
	load_upgrades(BODY_UPGRADES_DIR,body_upgrades)

	#loads money from settings_manager.gd, if there's none sets it to default
	money = int(SettingsManager.get_money(starting_money))
	emit_signal("money_changed")

func load_upgrades(dir: String, arr: Array[PonyUpgrade]) -> void:
	var da = DirAccess.open(dir)
	if da == null:
		push_error("Could not open directory: %s" % dir)
		return

	da.list_dir_begin()
	var file_name := da.get_next()
	while file_name != "":
		# skip dotfiles and the "scenes" folder
		if !da.current_is_dir() and file_name != "scenes":
			var path = dir.path_join(file_name)
			var res = load(path)
			if res != null:
				arr.append(res)
		file_name = da.get_next()
	da.list_dir_end()


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
