extends UpgradeOverlayScene
## Fades the full bottle sprite towards the empty sprite
## with diminishing fuel

@export var sprite_full: Sprite2D
@export var sprite_empty: Sprite2D
@export var particles: ThrustParticles



func _ready() -> void:
	pony.fuel_ran_out.connect(on_fuel_empty)

	pony.start_propulsion.connect(func():
		particles.set_active(true))

	pony.stop_propulsion.connect(func():
		particles.set_active(false))


func _physics_process(delta: float) -> void:
	var fuel_ratio: float= pony.get_fuel_ratio()
	sprite_full.modulate.a= fuel_ratio
	sprite_empty.modulate.a= 1.0 - fuel_ratio


func on_fuel_empty():
	set_physics_process(false)
