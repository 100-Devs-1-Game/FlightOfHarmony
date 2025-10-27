extends UpgradeOverlayScene

@export var flame_sprite: AnimatedSprite2D
@export var particles: ThrustParticles



func _ready() -> void:
	flame_sprite.hide()
	
	pony.start_propulsion.connect(func():
		$AudioStreamPlayer.play()
		flame_sprite.show()
		flame_sprite.play("default")
		particles.set_active(true))
	pony.stop_propulsion.connect(func():
		flame_sprite.hide()
		flame_sprite.stop()
		particles.set_active(false))
