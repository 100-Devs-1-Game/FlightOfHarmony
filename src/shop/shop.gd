extends CanvasLayer

@export var pony_stats: PonyStats
@export var money_label: Label
@export var upgrade_book: PackedScene



func _ready() -> void:
	Global.money_changed.connect(_update_currency)
	_update_currency()


func _on_texture_button_launch_pressed() -> void:
	LevelManager.goto_flight()


func _on_texture_button_fuel_pressed() -> void:
	pass # Replace with function body.


func _on_texture_button_back_pressed() -> void:
	LevelManager.goto_start()


func _update_currency() -> void:
	money_label.text = "Money: $" + str(Global.money)


func _on_reset_pressed() -> void:
	Global.set_currency(Global.starting_money)
	pony_stats.reset_all_upgrades()
	EventChannel.reset_progress.emit()
	_update_currency()


func _on_open_book_pressed(category: ShopUpgrade.Category) -> void:
	var book = upgrade_book.instantiate()
	book.category= category
	add_child(book)
