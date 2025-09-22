class_name PonyStats
extends Resource

enum StatEnum { SPEED, DRAG, LIFT, FUEL }

# store equipped items here and add stat to value via enum 
#  when returning

@export var speed_stat: SinglePonyStat
@export var drag_stat: SinglePonyStat
@export var lift_stat: SinglePonyStat
@export var fuel_stat: SinglePonyStat

@export var stat_levels: Array[int]= [ 0, 0, 0, 0 ]



func get_stat_value(stat: StatEnum)-> float:
	var val: float= 0.0
	var level: int= stat_levels[int(stat)]

	return get_stat(stat).get_value(level)


func get_stat(stat: StatEnum)-> SinglePonyStat:
	match stat:
		StatEnum.SPEED:
			return speed_stat
		StatEnum.DRAG:
			return drag_stat
		StatEnum.LIFT:
			return lift_stat
		StatEnum.FUEL:
			return fuel_stat
		_:
			assert(false)
			return null


func get_level(stat: StatEnum)-> int:
	return stat_levels[int(stat)]



func set_level(stat: StatEnum, level: int):
	stat_levels[int(stat)]= level
