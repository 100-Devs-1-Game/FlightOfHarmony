class_name PonyStats
extends Resource
## Holds all the ponys stats and upgrades

enum StatType { SPEED, DRAG, LIFT, FUEL, JUMP_HEIGHT, PROPULSION }


@export var speed_stat: BuyablePonyStat
@export var drag_stat: SinglePonyStat
@export var lift_stat: SinglePonyStat
@export var fuel_stat: BuyablePonyStat
@export var jump_height_stat: BuyablePonyStat
@export var propulsion_stat: SinglePonyStat

## Holds upgrades according to ShopUpgrade.Category order
@export var upgrade_slots: Array[ShopUpgrade] = [null, null, null, null]



func get_stat(stat: StatType) -> SinglePonyStat:
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
		StatType.JUMP_HEIGHT:
			return jump_height_stat
		StatType.PROPULSION:
			return propulsion_stat
		_:
			assert(false)
			return null


func get_stats()-> Array[SinglePonyStat]:
	var result: Array[SinglePonyStat]
	for stat in StatType.values():
		result.append(get_stat(stat))
	return result


func get_level(stat: StatType) -> int:
	var s = get_stat(stat)
	if s == null: 
		return 0
	return s.level


func set_level(stat: StatType, level: int) -> void:
	var s = get_stat(stat)
	if s:
		s.level= level
		SaveManager.save_game()
	else:
		push_error(str("Can't find stat ", stat))


func get_stat_value(stat: StatType) -> float:
	var s = get_stat(stat)
	if s == null:
		return 0.0
	var level = get_level(stat)
	var bonus = 0.0
	for upgrade in upgrade_slots:
		if upgrade and upgrade is PonyUpgrade:
			bonus += upgrade.get_stat_modifier(stat)
	return s.get_value(level + bonus)


func get_upgrade(category: ShopUpgrade.Category) -> ShopUpgrade:
	return upgrade_slots[int(category)]


func set_upgrade(upgrade: ShopUpgrade, category: ShopUpgrade.Category) -> void:
	upgrade_slots[int(category)] = upgrade


func reset_all_upgrades() -> void:
	for stat in get_stats():
		stat.level= 0

	for i in range(upgrade_slots.size()):
		upgrade_slots[i] = null

	SaveManager.save_game()
