class_name PonyUpgrade
extends Resource
## Holds an upgrade ( item ) that can be bought in the shop

enum Category { GLIDER, PROPULSION, BODY }

@export var display_name: String
@export var category: Category
@export var cost: int
## Icon for the shop
@export var icon: Texture2D
## An overlay for the flying pony animation adding this upgrades appearance
@export var sprite: Texture

## All the stats this upgrade modifies
@export var pony_stat_modifiers: Array[PonyStatModifier]



## Get the value this upgrade changes for a given stat
func get_stat_modifier(stat: PonyStats.StatType)-> int:
	var result:= 0
	for modifier in pony_stat_modifiers:
		if stat == modifier.stat:
			result+= modifier.value
	return result
