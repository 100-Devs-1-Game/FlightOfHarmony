class_name PonyStats
extends Resource
## Holds all the ponys stats and upgrades

enum StatType { SPEED, DRAG, LIFT, FUEL, JUMP_HEIGHT }


@export var speed_stat: SinglePonyStat
@export var drag_stat: SinglePonyStat
@export var lift_stat: SinglePonyStat
@export var fuel_stat: SinglePonyStat
@export var jump_height_stat: SinglePonyStat

## Holds upgrades according to PonyUpgrade.Category order
@export var upgrade_slots: Array[PonyUpgrade] = [null, null, null]

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
		_:
			assert(false)
			return null


func get_level(stat: StatType) -> int:
	var s = get_stat(stat)
	if s == null: 
		return 0
	return SettingsManager.get_level(s.id, 0)


func set_level(stat: StatType, level: int) -> void:
	var s = get_stat(stat)
	if s:
		SettingsManager.set_level(s.id, level)
		SettingsManager.save_game()


func get_stat_value(stat: StatType) -> float:
	var s = get_stat(stat)
	if s == null:
		return 0.0
	var level = get_level(stat)
	var bonus = 0.0
	for upgrade in upgrade_slots:
		if upgrade:
			bonus += upgrade.get_stat_modifier(stat)
	return s.get_value(level) + bonus


func get_upgrade(category: PonyUpgrade.Category) -> PonyUpgrade:
	return upgrade_slots[int(category)]


func set_upgrade(upgrade: PonyUpgrade, category: PonyUpgrade.Category) -> void:
	upgrade_slots[int(category)] = upgrade


func reset_all_upgrades() -> void:
	for stat in StatType.values():
		var s := get_stat(stat)
		if s:
			SettingsManager.set_level(s.id, 0)

	for i in range(upgrade_slots.size()):
		upgrade_slots[i] = null

	SettingsManager.save_game()
