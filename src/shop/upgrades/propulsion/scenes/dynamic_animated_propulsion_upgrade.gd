extends UpgradeOverlayScene

@export var propulsion_animation: AnimatedSprite2D



func _ready() -> void:
	pony.start_propulsion.connect(func():
		propulsion_animation.play("default"))
	pony.stop_propulsion.connect(func():
		propulsion_animation.stop())
