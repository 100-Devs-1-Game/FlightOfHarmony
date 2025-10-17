extends Node

const VERSION= 1

@export var save_path: String
@export var reset_game: bool= false
@export var pony_stats: PonyStats

var bought_upgrades: Array[ShopUpgrade]



func _ready() -> void:
	load_game()
	get_tree().root.connect("tree_exiting", Callable(self, "_on_tree_exiting"))


func save_game() -> void:
	var dict: Dictionary
	
	dict["version"]= VERSION
	dict["money"]= Global.money
	dict["day"]= Global.day
	
	var arr_levels:= []
	for stat in pony_stats.get_stats():
		assert(stat.level == 0 or stat is BuyablePonyStat)
		arr_levels.append(stat.level)
	dict["levels"]= arr_levels

	var arr_upgrades:= []
	for upgrade in pony_stats.upgrade_slots:
		if upgrade:
			arr_upgrades.append(upgrade.resource_path)
		else:
			arr_upgrades.append("")

	dict["active_upgrades"]= arr_upgrades
	
	var arr_bought:= []
	for upgrade in bought_upgrades:
		arr_bought.append(upgrade.resource_path)
		
	dict["bought_upgrades"]= arr_bought
	
	var file:= FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(dict))
	file.close()


func load_game() -> void:
	if not FileAccess.file_exists(save_path):
		return
	
	var dict: Dictionary= JSON.parse_string(FileAccess.get_file_as_string(save_path))

	if not dict.has("version"):
		return
	
	var save_version: int= dict["version"]
	if save_version < VERSION:
		return

	Global.money= dict["money"]
	Global.day= dict["day"]

	var arr: Array= dict["levels"]
	for stat in pony_stats.get_stats():
		stat.level= arr.pop_front()
		assert(stat.level == 0 or stat is BuyablePonyStat)
	
	arr= dict["active_upgrades"]
	for i in pony_stats.upgrade_slots.size():
		var upgrade_path: String= arr.pop_front()
		if upgrade_path:
			pony_stats.upgrade_slots[i]= load(upgrade_path)

	arr= dict["bought_upgrades"]
	for path: String in arr:
		bought_upgrades.append(load(path))


func reset():
	bought_upgrades.clear()


func _on_tree_exiting() -> void:
	save_game()
