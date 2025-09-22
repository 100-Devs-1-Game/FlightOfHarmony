class_name FlyingPony
extends CharacterBody2D

signal has_reset
signal started_flying

enum State { WALKING, FLYING, LANDING }

@export var walk_distance: float= 100.0
@export var rotation_speed: float= 2.0
@export var gravity: float= 100.0
@export var maximum_drag: float= 0.5
@export var perfect_lift_angle: float= 20

@export var stats: PonyStats

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var orig_pos: Vector2= position

var state: State
var enable_lift: bool= false



func _ready() -> void:
	reset.call_deferred()


func reset():
	position= Vector2(orig_pos)
	rotation= 0.0
	velocity= stats.get_stat_value(PonyStats.StatEnum.SPEED) * Vector2.RIGHT
	state= State.WALKING
	enable_lift= false
	
	
func jump():
	state= State.FLYING
	if animated_sprite:
		animated_sprite.play("flight")
	var jump_angle: float= stats.get_stat_value(PonyStats.StatEnum.JUMP_ANGLE)
	velocity= velocity.length() * Vector2.from_angle(-deg_to_rad(jump_angle))


func _physics_process(delta: float) -> void:
	match state:
		State.WALKING:
			position.x+= velocity.x * delta
			if position.x >= walk_distance:
				jump()
		State.FLYING:
			fly_logic(delta)


func fly_logic(delta: float):
	velocity.y+= gravity * delta
	
	var drag: float= get_drag()
	velocity.x*= 1 - drag * delta

	if enable_lift:
		var lift: float= get_lift()
		velocity+= -global_transform.y * velocity.dot(global_transform.x) * lift * delta
	
	var prev_y: float= position.y
	if move_and_collide(velocity * delta):
		state= State.LANDING
		rotation= 0
		if animated_sprite:
			animated_sprite.play("default")
		return
	
	if prev_y < position.y:
		enable_lift= true
	
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
	var lift_factor: float= max(0, pow(dot, 3) * velocity.length())
	return lerp(0.0, maximum_lift, lift_factor * 0.002)
	
