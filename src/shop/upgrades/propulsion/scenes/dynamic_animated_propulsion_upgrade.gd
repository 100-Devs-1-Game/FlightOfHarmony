class_name DynamicAnimatedPropulsionOverlay
extends UpgradeOverlayScene

@export var propulsion_animation: AnimatedSprite2D
@export var particles: ThrustParticles


func _ready() -> void:
	pony.start_propulsion.connect(func():
		if propulsion_animation:
			propulsion_animation.play("default")
		if particles:
			particles.set_active(true))

	pony.stop_propulsion.connect(func():
		if propulsion_animation:
			propulsion_animation.stop()
		if particles:
			particles.set_active(false))

	
