class_name PonyStats
extends Resource
## Holds all the ponys stats and upgrades

enum StatType { SPEED, DRAG, LIFT, FUEL, JUMP_HEIGHT }


@export var speed_stat: SinglePonyStat
@export var drag_stat: SinglePonyStat
@export var lift_stat: SinglePonyStat
@export var fuel_stat: SinglePonyStat
@export var jump_height_stat: SinglePonyStat

## The initial level per stat, according to StatType order
@export var stat_levels: Array[int]= [ 0, 0, 0, 0, 0 ]

## Holds upgrades according to PonyUpgrade.Category order
@export var upgrade_slots: Array[PonyUpgrade]= [ null, null, null ]



## Returns the stat value combining the base value,
## the level and potential upgrades influencing the stat
func get_stat_value(stat: StatType)-> float:
	var level: int= stat_levels[int(stat)]
	
	var bonus:= 0
	for upgrade in upgrade_slots:
		if not upgrade:
			continue
		bonus+= upgrade.get_stat_modifier(stat)

	return get_stat(stat).get_value(level) + bonus


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
		StatType.JUMP_HEIGHT:
			return jump_height_stat
		_:
			assert(false)
			return null


func set_level(stat: StatType, level: int):
	stat_levels[int(stat)]= level


func set_upgrade(upgrade: PonyUpgrade, category: PonyUpgrade.Category):
	upgrade_slots[int(category)]= upgrade


func get_level(stat: StatType)-> int:
	return stat_levels[int(stat)]


func get_upgrade(category: PonyUpgrade.Category)-> PonyUpgrade:
	return upgrade_slots[int(category)]
