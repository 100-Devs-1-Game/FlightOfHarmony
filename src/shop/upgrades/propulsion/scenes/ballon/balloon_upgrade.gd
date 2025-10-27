extends DynamicAnimatedPropulsionOverlay

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	pony.start_propulsion.connect(func():
		$"AudioStreamPlayer Release".play())
	pony.stop_propulsion.connect(func():
		$"AudioStreamPlayer Release".stop()
		$"AudioStreamPlayer Pop".play()
		sprite.hide())
		

func _physics_process(delta: float) -> void:
	var fuel_ratio: float= pony.get_fuel_ratio()
	sprite.scale= lerp(Vector2.ONE * 0.3, Vector2.ONE, fuel_ratio) 
