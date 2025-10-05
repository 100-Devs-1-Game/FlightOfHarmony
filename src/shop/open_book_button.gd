extends Button

signal open_book(category: ShopUpgrade.Category)

@export var category: ShopUpgrade.Category

@onready var texture_rect: TextureRect = $TextureRect



func _ready() -> void:
	pass


func _on_pressed() -> void:
	open_book.emit(category)
