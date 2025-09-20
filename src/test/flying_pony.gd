extends CharacterBody2D

enum State { PREPPING, FLYING, LANDING }

@export var walk_distance: float= 100.0
@export var jump_angle: int= 45
@export var rotation_speed: float= 2.0
@export var gravity: float= 10.0
@export var maximum_drag: float= 0.5
@export var perfect_lift_angle: float= 20

@export var stats: PonyStats


var state: State



func _ready() -> void:
	reset()


func reset():
	position= Vector2.ZERO
	velocity= stats.get_stat_value(PonyStats.StatEnum.SPEED) * Vector2.RIGHT
	state= State.PREPPING
	
	
func jump():
	state= State.FLYING
	velocity= velocity.length() * Vector2.from_angle(-deg_to_rad(jump_angle))


func _physics_process(delta: float) -> void:
	match state:
		State.PREPPING:
			position.x+= velocity.x * delta
			if position.x >= walk_distance:
				jump()
		State.FLYING:
			fly_logic(delta)


func fly_logic(delta: float):
	velocity.y+= gravity * delta
	velocity.x*= 1 - get_drag() * delta
	velocity+= -global_transform.y * velocity.dot(global_transform.x) * get_lift() * delta
	
	if move_and_collide(velocity * delta):
		state= State.LANDING
	
	var rot_inp= Input.get_axis("rotate_left", "rotate_right")
	rotate(rot_inp * rotation_speed * delta)


func get_drag()-> float:
	var optimal_drag: float= stats.get_stat_value(PonyStats.StatEnum.DRAG)
	var dot: float= global_transform.x.dot(velocity.normalized())
	return lerp(maximum_drag, optimal_drag, clampf(dot, 0.0, 1.0))


func get_lift()-> float:
	var perfect_angle: Vector2= velocity.normalized().rotated(-deg_to_rad(perfect_lift_angle))
	var dot: float= global_transform.x.dot(perfect_angle)
	var maximum_lift: float= stats.get_stat_value(PonyStats.StatEnum.LIFT)
	return lerp(0.0, maximum_lift, clampf(pow(dot, 3), 0.0, 1.0))
	
