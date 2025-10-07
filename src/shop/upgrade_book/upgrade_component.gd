class_name UpgradeComponent
extends Control

signal updated

const CAN_BUY = preload("res://assets/art/upgrades/book/icons/BuyIcon_Selected.png")
const CANT_AFFORD = preload("res://assets/art/upgrades/book/icons/BuyIcon_Cant Afford.png")
const ITEM_SOLD = preload("res://assets/art/upgrades/book/icons/BuyIcon_Sold.png")

@export var res: ShopUpgrade

@onready var selector: BaseButton = $Selector
@onready var display_label: Label = $HBoxContainer/ItemName
@onready var cost_label: Label = $HBoxContainer/ItemPrice
@onready var texture: TextureRect = $Selector/Texture
@onready var first_bar: TextureProgressBar = $StatbarContainer/A
@onready var second_bar: TextureProgressBar = $StatbarContainer/B



func _ready() -> void:
	if selector:
		selector.mouse_entered.connect(_enter)
		selector.mouse_exited.connect(_exit)


func init(_res: ShopUpgrade):
	res= _res
	selector.pressed.connect(_on_upgrade_pressed.bind(res))
	_update_from_res()
	check_affordable()
	Global.money_changed.connect(check_affordable)


func check_affordable() -> void:
	$Sold.hide()
	if res in SaveManager.bought_upgrades:
		var selected:= res in SaveManager.pony_stats.upgrade_slots
		selector.texture_normal = CAN_BUY if selected else null
		selector.texture_hover = CAN_BUY
		selector.texture_pressed = CAN_BUY
		if not selected:
			$Sold.show()
	elif Global.can_afford(res.cost):
		selector.texture_normal = null
		selector.texture_hover = CAN_BUY
		selector.texture_pressed = CAN_BUY
	else:
		selector.texture_normal = CANT_AFFORD
		selector.texture_hover = CANT_AFFORD
		selector.texture_pressed = CANT_AFFORD


func _enter() -> void:
	if res:
		EventChannel.item_hovered.emit(res.item_description, true)


func _exit() -> void:
	EventChannel.item_hovered.emit("", false)


func _update_from_res() -> void:
	name = res.display_name
	display_label.text = res.display_name
	cost_label.text = "$%d.00" % int(res.cost)
	texture.texture = res.icon

	if res is MoneyUpgrade:
		%StatbarContainer.hide()
		return

	var first_stat: PonyStatModifier= res.pony_stat_modifiers[0]
	var second_stat: PonyStatModifier

	if res.pony_stat_modifiers.size() > 1:
		second_stat= res.pony_stat_modifiers[1]

	first_bar.get_child(0).text = first_stat.get_display_name()
	first_bar.value= first_stat.value

	if second_stat:
		second_bar.get_child(0).text = second_stat.get_display_name()
		second_bar.value= second_stat.value
	else:
		second_bar.hide()


func _on_upgrade_pressed(upgrade: ShopUpgrade) -> void:
	if not upgrade in SaveManager.bought_upgrades:
		if Global.try_spend(upgrade.cost):
			#$Sold.visible = true
			SaveManager.bought_upgrades.append(upgrade)
			SaveManager.save_game()

	SaveManager.pony_stats.set_upgrade(upgrade, upgrade.category)
	updated.emit()
