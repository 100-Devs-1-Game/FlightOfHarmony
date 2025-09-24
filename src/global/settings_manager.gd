extends Node

var levels: Dictionary = {} 
#I'll reorganize all this later, stuff starting getting
#mixed together since I haven't slept 😅

const SAVE_PATH := "user://upgrades.cfg"
const SEC_LEVELS := "levels"
const SEC_MONEY := "money"
const KEY_BALANCE := "balance"

var _money_loaded: bool = false
var _cached_money: int = 0

var reset_on_startup: bool = false

func _ready() -> void:
	load_game()
	get_tree().root.connect("tree_exiting", Callable(self, "_on_tree_exiting"))
	if reset_on_startup:
		set_money(200)
		save_game()

func set_level(id: StringName, level: int) -> void:
	levels[id] = level

func get_level(id: StringName, default_level: int = 0) -> int:
	return int(levels.get(id, default_level))

func set_money(value: int) -> void:
	if value < 0:
		value = 0
	_cached_money = value
	_money_loaded = true

func get_money(default_value: int = 0) -> int:
	if _money_loaded:
		return _cached_money
	return default_value

func save_game() -> void:
	var cfg = ConfigFile.new()

	for id in levels.keys():
		cfg.set_value(SEC_LEVELS, String(id), int(levels[id]))

	cfg.set_value(SEC_MONEY, KEY_BALANCE, _cached_money)

	var err = cfg.save(SAVE_PATH)
	if err != OK:
		push_warning("Failed to save settings: " + str(err))
	else:
		#print("Saved levels:", levels, " | money:", _cached_money)
		pass

func load_game() -> void:
	levels.clear()
	_money_loaded = false
	_cached_money = 0

	var cfg = ConfigFile.new()
	var err = cfg.load(SAVE_PATH)
	if err != OK:
		print("No save yet, starting fresh.")
		return

	if cfg.has_section(SEC_LEVELS):
		for key in cfg.get_section_keys(SEC_LEVELS):
			levels[StringName(key)] = int(cfg.get_value(SEC_LEVELS, key))

	if cfg.has_section_key(SEC_MONEY, KEY_BALANCE):
		_cached_money = int(cfg.get_value(SEC_MONEY, KEY_BALANCE))
		_money_loaded = true

	#print("Loaded levels:", levels, " | money:", _cached_money)

func _on_tree_exiting() -> void:
	save_game()
