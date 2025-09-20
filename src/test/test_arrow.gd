extends Node2D

@export var color: Color

@onready var line: Line2D = $Line2D



func _ready() -> void:
	line.default_color= color


func set_size(size: float):
	line.scale= Vector2.ONE * size
