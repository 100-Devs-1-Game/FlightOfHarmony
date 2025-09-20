class_name PonyStat
extends Resource

@export var base_value: float
@export var step_value: float



func get_value(level: int)-> float:
	return base_value + level * step_value
