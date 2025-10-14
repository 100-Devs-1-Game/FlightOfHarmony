class_name Shop
extends CanvasLayer

@export var pony_stats: PonyStats
@export var upgrade_book_scene: PackedScene
@export var book_buttons: Array[BookCategoryButton]

@onready var money_label: Label = $MoneyLabel
@onready var fuel_label: Label = $FuelLabel
@onready var buy_fuel_label: Label = $BuyFuelLabel


func _ready() -> void:
	Global.money_changed.connect(_update_currency)
	_update_currency()
	_update_fuel()


func _on_texture_button_launch_pressed() -> void:
	LevelManager.goto_flight()


func _on_texture_button_fuel_pressed() -> void:
	var level: int= pony_stats.get_level(PonyStats.StatType.FUEL)
	pony_stats.set_level(PonyStats.StatType.FUEL, level + 1)
	Global.try_spend(pony_stats.get_fuel_cost())
	_update_fuel()
	

func _on_texture_button_back_pressed() -> void:
	LevelManager.goto_start()


func _update_currency() -> void:
	money_label.text = str("$", Global.money)


func _update_fuel() -> void:
	fuel_label.text = str(int(pony_stats.get_stat_value(PonyStats.StatType.FUEL)), " L")
	buy_fuel_label.text= str("$", pony_stats.get_fuel_cost())


func _on_reset_pressed() -> void:
	Global.set_currency(Global.starting_money)
	pony_stats.reset_all_upgrades()
	EventChannel.reset_progress.emit()
	_update_currency()


func _on_open_book_pressed(category: ShopUpgrade.Category) -> void:
	var book: UpgradeBook = upgrade_book_scene.instantiate()
	book.category= category
	book.close.connect(on_upgrade_book_closed)
	add_child(book)


func on_upgrade_book_closed():
	for button in book_buttons:
		button.update()
