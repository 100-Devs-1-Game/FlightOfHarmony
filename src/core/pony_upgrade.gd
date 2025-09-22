class_name PonyUpgrade
extends Resource

enum Category { GLIDER, PROPULSION, BODY }

@export var display_name: String
@export var category: Category
@export var cost: int
@export var icon: Texture2D
@export var sprite: Texture

@export var pony_stat_modifiers: Array[PonyStatModifier]



func get_stat_modifier(stat: PonyStats.StatType)-> int:
	var result:= 0
	for modifier in pony_stat_modifiers:
		if stat == modifier.stat:
			result+= modifier.value
	return result
