extends CharacterBody2D

enum State { PREPPING, FLYING, LANDING }

#@export var walk_speed: float= 100.0
#@export var walk_duration: float= 1.0
@export var walk_distance: float= 100.0
@export var jump_angle: int= 45
@export var rotation_speed: float= 2.0
@export var gravity: float= 10.0

@export var stats: PonyStats


var state: State



func _ready() -> void:
	reset()


func reset():
	position= Vector2.ZERO
	velocity= stats.get_initial_speed() * Vector2.RIGHT
	state= State.PREPPING
	
	
func jump():
	state= State.FLYING
	velocity= stats.get_initial_speed() * Vector2.from_angle(-deg_to_rad(jump_angle))


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
	if move_and_collide(velocity * delta):
		state= State.LANDING
	
	var rot_inp= Input.get_axis("rotate_left", "rotate_right")
	rotate(rot_inp * rotation_speed * delta)
