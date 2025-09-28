class_name PonyStatModifier
extends Resource
## Used to describe the value of a single stat changed by
## a PonyUpgrade
## For example a Glider that adds level 3 lift:
## ( Lift, 3 ) => should show a Bar called "Lift" with 3 bars
## in the Upgrade Book


## Which flying pony stat are we modifying
@export var stat: PonyStats.StatType
## The level of this stat ( 0 - 10 )
@export var value: int



func get_display_name()-> String:
	return PonyStats.StatType.keys()[stat]
