extends Camera2D

@export var follow: CharacterBody2D



func _process(delta: float) -> void:
	position= follow.position
