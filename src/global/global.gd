extends Node

const GLIDER_UPGRADES_DIR= "res://shop/upgrades/gliders/"

var glider_upgrades: Array[PonyUpgrade]



func _ready() -> void:
	load_upgrades(GLIDER_UPGRADES_DIR, glider_upgrades)
	# TODO
	# same for propulsion and body upgrades ( folders/items don't exist yet )


func load_upgrades(dir: String, arr: Array[PonyUpgrade]):
	for file in ResourceLoader.list_directory(dir):
		glider_upgrades.append(load(dir + "/" + file))
