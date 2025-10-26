class_name ShopUpgrade
extends Resource
 ## Holds an upgrade ( item ) that can be bought in the shop

enum Category { GLIDER, PROPULSION, BODY, MONEY }
 
@export var category: Category = Category.GLIDER

@export var display_name: String = "ITEM_NAME"
@export var item_description: String = "ITEM_DESCRIPTION"
@export var cost: int
## Icon for the shop
@export var icon: Texture2D



func get_display_name()-> String:
	return display_name
