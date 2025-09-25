class_name PonyUpgrade
extends Resource
## Holds an upgrade ( item ) that can be bought in the shop

enum Category { GLIDER, PROPULSION, BODY }

 
@export var display_name: String
@export var cost: int
## Icon for the shop
@export var icon: Texture2D
## An overlay for the flying pony animation adding this upgrades appearance
@export var overlay_scene: PackedScene
## All the stats this upgrade modifies
@export var pony_stat_modifiers: Array[PonyStatModifier]



## Get the value this upgrade changes for a given stat
func get_stat_modifier(stat: PonyStats.StatType)-> int:
	var result:= 0
	for modifier in pony_stat_modifiers:
		if stat == modifier.stat:
			result+= modifier.value
	return result


## Gets overridden in PonyUpgradeGlider/Propulsion/Body
## So far it isn't used, may turn out to be unnecessary
func get_category()-> Category:
	assert(false, "Abstract function")
	return Category.GLIDER
