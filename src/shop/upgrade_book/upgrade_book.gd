class_name UpgradeBook
extends Panel

signal close

@export var clickables: Array[BaseButton] = []
@export var pony_stats: PonyStats

@export var item_desc: Label
@export var animator: AnimationPlayer

@export var second_page_offset: float= 639
@export var upgrade_component_scene: PackedScene

@onready var pages: Control = %Pages

var _current_idx := 0
var category: ShopUpgrade.Category



func _ready() -> void:

	EventChannel.item_hovered.connect(update_and_display)

	for btn in clickables:
		if btn == null:
			continue
		btn.pressed.connect(_on_button_pressed.bind(StringName(btn.name)))

	for upgrade in Global.get_category_upgrades(category):
		var component: UpgradeComponent= upgrade_component_scene.instantiate()
		component.updated.connect(_on_component_updated)
		pages.add_child(component)
		component.init(upgrade)
		if pages.get_child_count() % 2 == 0:
			component.position.x= second_page_offset
	
	_apply_page_visibility()


func _handle_hover(state: bool, button: BaseButton) -> void:
	if button.has_method("get_description"):
		var desc = button.get_description()
		EventChannel.item_hovered.emit(desc, state)


func _on_button_pressed(action: StringName) -> void:
	match action:
		"BookBack":
			close.emit()
			queue_free.call_deferred()
		"BookNext":
			next_page()
		"BookPrevious":
			previous_page()


func next_page() -> void:
	if pages.get_child_count() == 0:
		return
	if _current_idx < pages.get_child_count() / 2:
		_current_idx += 1
	_apply_page_visibility()


func previous_page() -> void:
	if pages.get_child_count() == 0:
		return
	if _current_idx > 0:
		_current_idx -= 1
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
			item_desc.text = desc
		else:
			animator.play_backwards("toggle")


func _on_component_updated():
	for component: UpgradeComponent in pages.get_children():
		component.check_affordable()
