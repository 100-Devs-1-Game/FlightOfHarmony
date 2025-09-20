class_name PonyStats
extends Resource

enum Stat { SPEED, DRAG, LIFT }

# store equipped items here and add stat to value via enum 
#  when returning

@export var speed_stat: PonyStat
@export var drag_stat: PonyStat
@export var lift_stat: PonyStat

@export var stat_levels: Array[int]= [ 0, 0, 0 ]


func get_stat_value(stat: Stat)-> float:
	var val: float= 0.0
	var level: int= stat_levels[int(stat)]
	
	match stat:
		Stat.SPEED:
			val= speed_stat.get_value(level)
		Stat.DRAG:
			val= drag_stat.get_value(level)
		Stat.LIFT:
			val= lift_stat.get_value(level)
		_:
			assert(false)
	
	return val


func get_stat_value(stat: Stat)-> PonyStat:
	match stat:
		Stat.SPEED:
			return speed_stat
		Stat.DRAG:
			return drag_stat
		Stat.LIFT:
			return lift_stat
		_:
			assert(false)
			return null
