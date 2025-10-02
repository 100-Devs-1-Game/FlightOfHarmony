extends Panel

@export var clickables: Array[BaseButton] = []
@export var pony_stats: PonyStats

@export var item_desc: Label
@export var animator: AnimationPlayer

@export var second_page_offset: float= 639

@onready var pages: Control = %Pages

var _current_idx := 0



func _ready() -> void:

	EventChannel.item_hovered.connect(update_and_display)

	for btn in clickables:
		if btn == null:
			continue
		btn.pressed.connect(_on_button_pressed.bind(StringName(btn.name)))

	EventChannel.upgrade_item_clicked.connect(_on_purchase_pressed)

	_apply_page_visibility()


func _handle_hover(state: bool, button: BaseButton) -> void:
	if button.has_method("get_description"):
		var desc = button.get_description()
		EventChannel.item_hovered.emit(desc, state)


func _on_button_pressed(action: StringName) -> void:
	match action:
		"BookBack":
			call_deferred("queue_free")
		"BookNext":
			next_page()
		"BookPrevious":
			previous_page()


func _on_purchase_pressed(upgrade: PonyUpgrade) -> void:
	Global.try_spend(upgrade.cost)
	pony_stats.set_upgrade(upgrade, upgrade.get_category())


func next_page() -> void:
	if pages.get_child_count() == 0:
		return
	_current_idx += 1
	if _current_idx >= pages.get_child_count() / 2:
		_current_idx = 0
	_apply_page_visibility()

func previous_page() -> void:
	if pages.get_child_count() == 0:
		return
	if _current_idx > 0:
		_current_idx -= 1
	else:
		_current_idx = pages.get_child_count() / 2 - 1
	_apply_page_visibility()


func _apply_page_visibility() -> void:
	for i in pages.get_child_count():
		var page = pages.get_child(i)
		if page != null:
			page.visible = i / 2 == _current_idx


func update_and_display(desc: String, hovered: bool) -> void:
	if animator:
		if hovered:
			animator.play("toggle")
			$DescPanel/Desc.text = desc
		else:
			animator.play_backwards("toggle")
