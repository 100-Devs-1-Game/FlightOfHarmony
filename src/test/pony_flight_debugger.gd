extends Node2D

@onready var pony: FlyingPony= get_parent()

@onready var lift_arrow: Node2D = $"Lift Arrow"
@onready var drag_arrow: Node2D = $"Drag Arrow"



func on_reset():
	set_physics_process(false)
	lift_arrow.scale= Vector2.ZERO
	drag_arrow.scale= Vector2.ZERO


func on_started_flying():
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	var drag: float= pony.get_drag()
	drag_arrow.look_at(position + Vector2.LEFT)
	drag_arrow.scale= Vector2.ONE * drag * 10

	var lift: float= pony.get_lift()
	lift_arrow.scale= Vector2.ONE * lift * 10
