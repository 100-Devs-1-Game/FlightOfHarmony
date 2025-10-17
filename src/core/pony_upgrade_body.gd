class_name PonyUpgradeBody
extends PonyUpgrade

@export var custom_idle_head: Texture2D
@export var custom_flying_head: Texture2D
@export var custom_running_head: Texture2D



func get_category()-> Category:
	return Category.BODY
