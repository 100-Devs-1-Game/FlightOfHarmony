class_name BookCategoryButton
extends Button

signal open_book(category: ShopUpgrade.Category)

@export var category: ShopUpgrade.Category

@onready var shop: Shop= get_parent()
@onready var texture_rect: TextureRect = $TextureRect



func _ready() -> void:
	update()


func update():
	var upgrade: ShopUpgrade= shop.pony_stats.get_upgrade(category)
	if upgrade:
		texture_rect.texture= upgrade.icon


func _on_pressed() -> void:
	open_book.emit(category)
