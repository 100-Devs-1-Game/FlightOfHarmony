extends Camera2D

@export var follow: CharacterBody2D


func _process(delta: float) -> void:
	position= follow.position
	position.x= max(1920 / 2, position.x)
