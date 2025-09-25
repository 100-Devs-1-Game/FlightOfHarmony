extends Node2D

@onready var animated_sprite_flying_pony: AnimatedSprite2D = $"AnimatedSprite2D Flying Pony"


func _ready() -> void:
	# Remove potential custom scripts from upgrade scenes to be tested
	# Because those scripts expect a flying pony reference
	# .. but anything that runs in `_ready()` in those scripts will be
	# executed earlier than this code, so it's not perfect
	for child in get_children():
		if child is UpgradeOverlayScene:
			child.set_script(null)
			
	animated_sprite_flying_pony.play("flight")
