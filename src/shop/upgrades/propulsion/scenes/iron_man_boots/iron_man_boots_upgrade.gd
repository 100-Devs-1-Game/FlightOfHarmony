extends UpgradeOverlayScene

@export var flame_sprite: AnimatedSprite2D



func _ready() -> void:
	flame_sprite.hide()
	
	pony.start_propulsion.connect(func():
		flame_sprite.show()
		flame_sprite.play("default"))
	pony.stop_propulsion.connect(func():
		flame_sprite.hide()
		flame_sprite.stop())
