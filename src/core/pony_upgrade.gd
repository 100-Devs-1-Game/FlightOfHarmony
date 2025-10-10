class_name PonyUpgrade
extends ShopUpgrade

## An overlay for the flying pony animation adding this upgrades appearance
@export var overlay_scene: PackedScene
## All the stats this upgrade modifies
@export var pony_stat_modifiers: Array[PonyStatModifier]

## Overrides default walk animation ( not implemented yet )
@export var custom_walk_animation: String
## Overrides default flight animation ( not implemented yet )
@export var custom_flight_animation: String



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
	return category
