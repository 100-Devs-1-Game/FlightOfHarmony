class_name PonyStats
extends Resource

enum StatEnum { SPEED, DRAG, LIFT }

# store equipped items here and add stat to value via enum 
#  when returning

@export var speed_stat: PonyStat
@export var drag_stat: PonyStat
@export var lift_stat: PonyStat

@export var stat_levels: Array[int]= [ 0, 0, 0 ]



func get_stat_value(stat: StatEnum)-> float:
	var val: float= 0.0
	var level: int= stat_levels[int(stat)]
	
	match stat:
		StatEnum.SPEED:
			val= speed_stat.get_value(level)
		StatEnum.DRAG:
			val= drag_stat.get_value(level)
		StatEnum.LIFT:
			val= lift_stat.get_value(level)
		_:
			assert(false)
	
	return val


func get_stat(stat: StatEnum)-> PonyStat:
	match stat:
		StatEnum.SPEED:
			return speed_stat
		StatEnum.DRAG:
			return drag_stat
		StatEnum.LIFT:
			return lift_stat
		_:
			assert(false)
			return null


func get_level(stat: StatEnum)-> int:
	return stat_levels[int(stat)]



func set_level(stat: StatEnum, level: int):
	stat_levels[int(stat)]= level
