extends Control

@export var title: String
@export var pony_stats: PonyStats
@export var stat: PonyStats.StatType

@onready var title_label: Label = %"Title Label"
@onready var button_container: HBoxContainer = %HBoxContainer
@onready var balance_label: Label = %"Balance Label"



func _ready() -> void:
	await get_tree().process_frame
	EventChannel.reset_progress.connect(_refresh)
	Global.money_changed.connect(_on_money_changed)
	title_label.text = title

	_disable_buttons()
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
	_disable_buttons()
	SaveManager.save_game()
	_update_next_cost()


func _disable_buttons() -> void:
	var stat_res = pony_stats.get_stat(stat) as BuyablePonyStat

	var count = button_container.get_child_count()
	for i in range(count):
		var btn := button_container.get_child(i) as TextureButton
		btn.modulate.a= 1.0
		if i < stat_res.level:
			btn.disabled = true
		elif not Global.can_afford(stat_res.cost[i]):
			btn.modulate.a= 0.5
	

func _update_next_cost() -> void:
	var stat_res = pony_stats.get_stat(stat) as BuyablePonyStat
	if stat_res == null:
		balance_label.text = "-"
		return

	var cur_level: int= stat_res.level
	if cur_level >= 0 and cur_level < stat_res.cost.size():
		balance_label.text = str(stat_res.cost[cur_level])
	else:
		balance_label.text = "MAX"


func _refresh() -> void:
	for child in button_container.get_children():
		var btn := child as TextureButton
		if btn == null:
			continue
		btn.disabled = false
		if btn.has_method("set_pressed_no_signal"):
			btn.set_pressed_no_signal(false)
		else:
			btn.button_pressed = false

	_update_next_cost()


func _on_money_changed():
	_refresh()
	_disable_buttons()
