extends Control

@export var res: PonyUpgrade : set = _set_res
@export var purchase_id: String = "NONE"

@export var first_label_name: String = "FIRST"
@export var second_label_name: String = "SECOND"

@export_range(0.0, 100.0, 0.1) var first_value: float = 0.0 : set = _set_first_value
@export_range(0.0, 100.0, 0.1) var second_value: float = 0.0 : set = _set_second_value


@onready var selector: BaseButton = $Selector
@onready var display_label: Label = $HBoxContainer/ItemName
@onready var cost_label: Label = $HBoxContainer/ItemPrice
@onready var texture: TextureRect = $Selector/Texture
@onready var first_bar: TextureProgressBar = $StatbarContainer/A
@onready var second_bar: TextureProgressBar = $StatbarContainer/B

const CAN_BUY = preload("res://assets/art/upgrades/book/icons/BuyIcon_Selected.png")
const CANT_AFFORD = preload("res://assets/art/upgrades/book/icons/BuyIcon_Cant Afford.png")
const ITEM_SOLD = preload("res://assets/art/upgrades/book/icons/BuyIcon_Sold.png")

func _ready() -> void:
	if selector:
		selector.mouse_entered.connect(_enter)
		selector.mouse_exited.connect(_exit)
		selector.pressed.connect(func():
			if Global.can_afford(res.cost):
				EventChannel.item_clicked.emit(purchase_id, res); $Sold.visible = true)

	_update_from_res()
	_apply_values_to_bars()

	check_affordable()
	Global.money_changed.connect(check_affordable)

	if second_value <= 0.0:
		second_bar.visible = false

func check_affordable() -> void:
	if res:
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

func _set_res(value: PonyUpgrade) -> void:
	res = value
	_update_from_res()

func _set_first_value(v: float) -> void:
	first_value = v
	_apply_values_to_bars()

func _set_second_value(v: float) -> void:
	second_value = v
	_apply_values_to_bars()

func _apply_values_to_bars() -> void:
	if first_bar:
		first_bar.value = clampf(first_value, first_bar.min_value, first_bar.max_value)
	if second_bar:
		second_bar.value = clampf(second_value, second_bar.min_value, second_bar.max_value)

func _update_from_res() -> void:
	if res == null:
		return

	if name == "" or name != res.display_name:
		name = res.display_name

	if display_label:
		display_label.text = res.display_name

	if cost_label:
		cost_label.text = "$%d.00" % int(res.cost)

	if texture:
		if texture.texture != res.icon:
			texture.texture = res.icon

	if first_bar:
		first_bar.get_child(0).text = first_label_name
	if second_bar:
		second_bar.get_child(0).text = second_label_name
