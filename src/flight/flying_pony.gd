class_name FlyingPony
extends CharacterBody2D
## Handles the ponys flight physics


signal has_reset
signal started_flying

enum State { WALKING, FLYING, LANDING }

## How far to walk before jumping
@export var walk_distance: float= 100.0
## How fast to rotate when left/right are pressed
@export var rotation_speed: float= 2.0
## The initial take-off angle
@export var jump_angle: float= 30.0
@export var gravity: float= 100.0
## The drag ( air resistance ) when the pony is at a right angle to its traveling
## direction or inverted
@export var maximum_drag: float= 0.5
## The perfect angle of attack ( counter-clockwise ) compared to the traveling
## direction to achieve maximum lift
@export var perfect_lift_angle: float= 20
## Amount of fuel used while propulsion is active
@export var fuel_used_per_second: float= 1.0
## Acceleration force of active propulsion
@export var propulsion_force: float= 100.0

## Reference to the stats file
@export var stats: PonyStats

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var orig_pos: Vector2= position

var state: State= State.WALKING
## Lift effects only get enabled once the ponys jump arc has reached it's maximum
var enable_lift: bool= false
## How many frames the gravity stays disabled initially to simulate an 
## increased jump height
var jump_bonus_frames: int= 0
## Propulsion type provided by potential upgrade
var propulsion_type: PonyUpgrade.PropulsionType
## Current state of propulsion
var propulsion_active: bool
var remaining_fuel: float


func _ready() -> void:
	# defer to let the debug graphics catch up
	reset.call_deferred()


func reset():
	position= Vector2(orig_pos)
	rotation= 0.0
	
	velocity= stats.get_stat_value(PonyStats.StatType.SPEED) * Vector2.RIGHT
	jump_bonus_frames= int(stats.get_stat_value(PonyStats.StatType.JUMP_HEIGHT))
	remaining_fuel= stats.get_stat_value(PonyStats.StatType.FUEL)
	
	var upgrade: PonyUpgrade= stats.get_upgrade(PonyUpgrade.Category.PROPULSION)
	if upgrade:
		propulsion_type= upgrade.provides_propulsion

	state= State.WALKING
	enable_lift= false


func jump():
	state= State.FLYING
	if animated_sprite:
		animated_sprite.play("flight")
	velocity= velocity.length() * Vector2.from_angle(-deg_to_rad(jump_angle))
	look_at(position + velocity)


func land():
	state= State.LANDING
	velocity= Vector2.ZERO
	rotation= 0
	if animated_sprite:
		animated_sprite.play("default")


func _physics_process(delta: float) -> void:
	match state:
		State.WALKING:
			position.x+= velocity.x * delta
			if position.x >= walk_distance:
				jump()
		State.FLYING:
			fly_logic(delta)


func fly_logic(delta: float):
	if jump_bonus_frames > 0:
		jump_bonus_frames-= 1
	else:
		velocity.y+= gravity * delta

	if remaining_fuel > 0:
		match propulsion_type:
			PonyUpgrade.PropulsionType.CONTINUOUS:
				if not propulsion_active:
					if Input.is_action_pressed("propulsion"):
						propulsion_active= true
			PonyUpgrade.PropulsionType.DYNAMIC:
				propulsion_active= Input.is_action_pressed("propulsion")

		if propulsion_active:
			remaining_fuel-= fuel_used_per_second * delta
		
		velocity+= global_transform.x * propulsion_force * delta


	var drag: float= get_drag()
	# simple linear drag algorithm, may need to be changed into a quadratic one
	velocity.x*= 1 - drag * delta

	if enable_lift:
		var lift: float= get_lift()
		velocity+= -global_transform.y * velocity.dot(global_transform.x) * lift * delta

	var prev_y: float= position.y
	if move_and_collide(velocity * delta):
		land()
		return
	
	# enable lift calculations as soon as we're dropping
	if prev_y < position.y:
		enable_lift= true
	
	var rot_inp= Input.get_axis("rotate_left", "rotate_right")
	rotate(rot_inp * rotation_speed * delta)


func get_drag()-> float:
	var optimal_drag: float= stats.get_stat_value(PonyStats.StatType.DRAG)
	var dot: float= global_transform.x.dot(velocity.normalized())
	return lerp(maximum_drag, optimal_drag, clampf(dot, 0.0, 1.0))


func get_lift()-> float:
	var perfect_angle: Vector2= velocity.normalized().rotated(-deg_to_rad(perfect_lift_angle))
	var dot: float= global_transform.x.dot(perfect_angle)
	var maximum_lift: float= stats.get_stat_value(PonyStats.StatType.LIFT)
	# use exponential dot value to increase the impact of a perfect
	# angle of attack
	var lift_factor: float= max(0, pow(dot, 3) * velocity.length())
	# this function can currently return a value above the 'maximum_lift'
	return lerp(0.0, maximum_lift, lift_factor * 0.002)


func get_speed()-> float:
	return velocity.length()


func get_height()-> float:
	return abs(position.y - orig_pos.y)


func get_distance()-> float:
	return max(0, position.x - (orig_pos.x + walk_distance)) 
