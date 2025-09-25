extends Node2D

@onready var animated_sprite_flying_pony: AnimatedSprite2D = $"AnimatedSprite2D Flying Pony"


func _ready() -> void:
	animated_sprite_flying_pony.play("flight")
