class_name PonyStats
extends Resource

enum StatType { SPEED, DRAG, LIFT, FUEL }

# store equipped items here and add stat to value via enum 
#  when returning

@export var speed_stat: SinglePonyStat
@export var drag_stat: SinglePonyStat
@export var lift_stat: SinglePonyStat
@export var fuel_stat: SinglePonyStat

@export var stat_levels: Array[int]= [ 0, 0, 0, 0 ]



func get_stat_value(stat: StatType)-> float:
	var val: float= 0.0
	var level: int= stat_levels[int(stat)]

	return get_stat(stat).get_value(level)


func get_stat(stat: StatType)-> SinglePonyStat:
	match stat:
		StatType.SPEED:
			return speed_stat
		StatType.DRAG:
			return drag_stat
		StatType.LIFT:
			return lift_stat
		StatType.FUEL:
			return fuel_stat
		_:
			assert(false)
			return null


func get_level(stat: StatType)-> int:
	return stat_levels[int(stat)]



func set_level(stat: StatType, level: int):
	stat_levels[int(stat)]= level
