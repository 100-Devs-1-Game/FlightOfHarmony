extends Camera2D

@export var follow_node: CharacterBody2D



## follow the pony but not for pony.position.x < 0
func _process(_delta: float) -> void:
	position= follow_node.position
	position.x= max(1920 / 2.0, position.x)
