extends UpgradeOverlayScene

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	animated_sprite.hide()
	
	pony.start_propulsion.connect(func():
		animated_sprite.show()
		animated_sprite.play("default"))
	pony.stop_propulsion.connect(func():
		animated_sprite.hide()
		animated_sprite.stop())
