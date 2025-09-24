extends Control

@export var title: String
@export var pony_stats: PonyStats
@export var stat: PonyStats.StatType

@onready var title_label: Label = %"Title Label"
@onready var button_container: HBoxContainer = %HBoxContainer
@onready var balance_label: Label = %"Balance Label"

func _ready() -> void:
	await get_tree().process_frame
	title_label.text = title

	var s = pony_stats.get_stat(stat)
	if s:
		var saved := SettingsManager.get_level(s.id, 0)
		_disable_buttons(saved)
	_update_next_cost()

	var level = 1
	for child: TextureButton in button_container.get_children():
		child.pressed.connect(_on_level_up.bind(level))
		level += 1


func _on_level_up(level: int) -> void:
	var stat_res = pony_stats.get_stat(stat) as BuyablePonyStat
	if stat_res == null:
		return

	var idx = level - 1
	if idx < 0 or idx >= stat_res.cost.size():
		return
	var cost = stat_res.cost[idx]

	if !Global.try_spend(cost):
		return

	pony_stats.set_level(stat, level)
	_disable_buttons(level)
	SettingsManager.save_game()
	_update_next_cost()


func _disable_buttons(level: int) -> void:
	var count = button_container.get_child_count()
	for i in range(level):
		if i < count:
			var btn := button_container.get_child(i) as TextureButton
			if btn:
				btn.disabled = true


func _update_next_cost() -> void:
	var stat_res = pony_stats.get_stat(stat) as BuyablePonyStat
	if stat_res == null:
		balance_label.text = "-"
		return

	var cur_level = SettingsManager.get_level(stat_res.id, 0)
	if cur_level >= 0 and cur_level < stat_res.cost.size():
		balance_label.text = str(stat_res.cost[cur_level])
	else:
		balance_label.text = "MAX"
