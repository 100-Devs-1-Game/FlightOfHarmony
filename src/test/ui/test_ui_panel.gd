extends PanelContainer

signal reset_pony

@export var pony: FlyingPony
@export var stat_panel_scene: PackedScene

@onready var label_distance: Label = %"Label Distance"



func _on_button_reset_pressed() -> void:
	reset_pony.emit()


func _physics_process(_delta: float) -> void:
	label_distance.text= "Distance: %d" % int(pony.get_distance() / 10)
