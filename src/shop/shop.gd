extends CanvasLayer

@export var pony_stats: PonyStats


func _on_texture_button_launch_pressed() -> void:
	LevelManager._load_level(LevelManager.FLIGHT)


func _on_texture_button_fuel_pressed() -> void:
	pass # Replace with function body.


func _on_texture_button_back_pressed() -> void:
	LevelManager._load_level(LevelManager.START)
