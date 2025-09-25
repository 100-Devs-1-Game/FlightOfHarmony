class_name PonyUpgradePropulsion
extends PonyUpgrade

enum Type { NONE, CONTINUOUS, DYNAMIC }
@export var provides_propulsion: Type= Type.NONE


func get_category()-> Category:
	return Category.PROPULSION
