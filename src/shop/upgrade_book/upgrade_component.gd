class_name UpgradeComponent
extends Control

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
		selector.pressed.connect(func():
			if Global.can_afford(res.cost):
				EventChannel.upgrade_item_clicked.emit(res); $Sold.visible = true)


func init(_res: ShopUpgrade):
	res= _res
	_update_from_res()
	check_affordable()
	Global.money_changed.connect(check_affordable)


func check_affordable() -> void:
	if res and not $Sold.visible:
		if Global.can_afford(res.cost):
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
