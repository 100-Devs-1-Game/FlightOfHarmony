class_name PonyStats
extends Resource

# TODO make Stat class ( base, step )
# stat name enum
# store levels in enum
# store equipped items here and add stat to value via enum 
#  when returning

@export var base_start_speed: float= 100.0
@export var start_speed_step: float= 20.0
@export var base_drag: float= 0.5
@export var drag_step: float= -0.02
@export var base_lift: float= 0.0
@export var lift_step: float= 0.01

@export var start_speed_level: int
@export var drag_level: int
@export var lift_level: int



func get_initial_speed()-> float:
	return base_start_speed + start_speed_level * start_speed_step


func get_drag()-> float:
	return base_drag + drag_level * drag_step


func get_lift()-> float:
	return base_lift + lift_level * lift_step
