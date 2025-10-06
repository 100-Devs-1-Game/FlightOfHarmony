class_name SinglePonyStat
extends Resource
## Describe a single stat

@export var display_name: String
@export var base_value: float
@export var step_value: float

var level: int


## calculate this stats value given a level
func get_value(level: int)-> float:
	return base_value + level * step_value
