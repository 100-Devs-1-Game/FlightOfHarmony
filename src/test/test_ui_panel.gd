extends PanelContainer

signal reset_pony

@export var stat_panel_scene: PackedScene



func _on_button_reset_pressed() -> void:
	reset_pony.emit()
