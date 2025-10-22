class_name BookCategoryButton
extends TextureButton

signal open_book(category: ShopUpgrade.Category)
signal empty_texture_replaced

@export var category: ShopUpgrade.Category
@export_multiline var empty_text: String
@export var empty_texture: Texture2D

@onready var shop: Shop= get_parent()
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label



func _ready() -> void:
	label.text= empty_text
	update()


func update():
	var upgrade: ShopUpgrade= shop.pony_stats.get_upgrade(category)
	if upgrade:
		if texture_rect.texture == empty_texture:
			empty_texture_replaced.emit()
		texture_rect.texture= upgrade.icon
		label.hide()
	else:
		texture_rect.texture= empty_texture
		label.show()


func _on_pressed() -> void:
	open_book.emit(category)
