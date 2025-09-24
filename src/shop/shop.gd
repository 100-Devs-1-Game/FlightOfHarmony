extends CanvasLayer

@export var pony_stats: PonyStats
@export var money_label: Label


func _ready() -> void:
	#pony_stats.reset_all_upgrades()
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
