class_name FlyingPony
extends CharacterBody2D
## Handles the ponys flight physics


signal has_reset
signal started_flying
signal landed
signal fuel_ran_out
signal start_propulsion
signal stop_propulsion

enum State { WALKING, FLYING, LANDING }

## Manually move the pony without any flight physics
@export var cheat_mode: bool= false
@export var test_flight: bool= false
## How far to walk before jumping
@export var walk_distance: float= 100.0
## How fast to rotate when left/right are pressed
@export var rotation_speed: float= 2.0
@export var rotation_acceleration: float= 1.0
## The initial take-off angle
@export var jump_angle: float= 30.0
@export var gravity: float= 100.0
## The drag ( air resistance ) when the pony is at a right angle to its traveling
## direction or inverted
@export var maximum_drag: float= 0.5
@export var drag_coefficient: float= 0.001
## The perfect angle of attack ( counter-clockwise ) compared to the traveling
## direction to achieve maximum lift
@export var perfect_lift_angle: float= -30
@export var back_lift_angle: float= 15.0
## Amount of fuel used while propulsion is active
@export var fuel_used_per_second: float= 1.0
## Acceleration force of active propulsion
@export var propulsion_force: float= 100.0

## Reference to the stats file
@export var stats: PonyStats

@export var idle_sprite: Sprite2D
@export var animated_run_sprite: AnimatedSprite2D
@export var animated_flight_sprite: AnimatedSprite2D

@onready var head_idle: Sprite2D = $HeadIdle
@onready var head_running: Sprite2D = $HeadRunning
@onready var head_flying: Sprite2D = $HeadFlying

@onready var orig_pos: Vector2= position

@onready var audio_trotting: AudioStreamPlayer = $"AudioStreamPlayer Trotting"
@onready var audio_wind: AudioStreamPlayer = $"AudioStreamPlayer Wind"

@onready var dirt_pile: Sprite2D = $"Sprite2D Dirt Pile"

var state: State= State.WALKING
## Lift effects only get enabled once the ponys jump arc has reached it's maximum
var enable_lift: bool= false
## How many frames the gravity stays disabled initially to simulate an 
## increased jump height
var jump_bonus_frames: int= 0
## Propulsion type provided by potential upgrade
var propulsion_type: PonyUpgradePropulsion.Type
## Current state of propulsion
var propulsion_active: bool:
	set(b):
		if propulsion_active == b:
			return
		propulsion_active= b
		if propulsion_active:
			start_propulsion.emit()
		else:
			stop_propulsion.emit()

var remaining_fuel: float
var top_speed: float
var current_rotation_speed: float= 0.0
var arcade_ratio: float

## parent node for all the upgrade overlays
var upgrade_overlays: Node2D


func _ready() -> void:
	# defer to let the debug graphics catch up
	if test_flight:
		stats.reset_all_upgrades(false)
	reset.call_deferred()


func reset():
	position= Vector2(orig_pos)
	rotation= 0.0
	
	velocity= stats.get_stat_value(PonyStats.StatType.SPEED) * Vector2.RIGHT
	jump_bonus_frames= int(stats.get_stat_value(PonyStats.StatType.JUMP_HEIGHT))
	remaining_fuel= stats.get_stat_value(PonyStats.StatType.FUEL)
	top_speed= stats.get_stat_value(PonyStats.StatType.TOP_SPEED)
	
	var upgrade: PonyUpgrade= stats.get_upgrade(ShopUpgrade.Category.PROPULSION)
	if upgrade:
		propulsion_type= upgrade.provides_propulsion
		propulsion_force*= stats.get_stat_value(PonyStats.StatType.PROPULSION)
	
	upgrade= stats.get_upgrade(ShopUpgrade.Category.BODY)
	if upgrade:
		var body_upgrade: PonyUpgradeBody= upgrade
		if body_upgrade.custom_idle_head:
			head_idle.texture= body_upgrade.custom_idle_head
		if body_upgrade.custom_running_head:
			head_running.texture= body_upgrade.custom_running_head
		if body_upgrade.custom_flying_head:
			head_flying.texture= body_upgrade.custom_flying_head
	
	state= State.WALKING
	play_animation()
	
	audio_trotting.play()
	audio_trotting.pitch_scale= 1 + stats.get_level(PonyStats.StatType.SPEED) * 0.05
	
	add_upgrade_overlays()

	#enable_lift= false
	enable_lift= true


func jump():
	state= State.FLYING
	play_animation()
	audio_trotting.stop()

	velocity= velocity.length() * Vector2.from_angle(-deg_to_rad(jump_angle))
	look_at(position + velocity)
	started_flying.emit()
	audio_wind.play()


func land():
	state= State.LANDING
	remove_upgrade_overlays()
	velocity= Vector2.ZERO
	audio_wind.stop()
	play_animation()
	idle_sprite.hide()
	dirt_pile.show()
	dirt_pile.global_rotation= 0
	$"AudioStreamPlayer Land".play()
	landed.emit()


func _physics_process(delta: float) -> void:
	if cheat_mode:
		position+= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * delta * 1000
		return
		
	match state:
		State.WALKING:
			position.x+= velocity.x * delta
			if position.x >= walk_distance:
				jump()
		State.FLYING:
			fly_logic(delta)


func fly_logic(delta: float):
	arcade_ratio= 0.0
	
	if jump_bonus_frames > 0:
		jump_bonus_frames-= 1
	else:
		velocity.y+= gravity * delta

	if remaining_fuel > 0:
		match propulsion_type:
			PonyUpgradePropulsion.Type.CONTINUOUS:
				if not propulsion_active:
					if Input.is_action_pressed("propulsion"):
						propulsion_active= true
			PonyUpgradePropulsion.Type.DYNAMIC:
				propulsion_active= Input.is_action_pressed("propulsion")

		if propulsion_active:
			remaining_fuel-= fuel_used_per_second * delta
			if remaining_fuel <= 0:
				fuel_ran_out.emit()
				propulsion_active= false
			else:
				velocity+= global_transform.x * propulsion_force * delta


	var drag: float= get_drag()
	var lost_velocity: float= velocity.length()
	velocity-= velocity.length_squared() * velocity.normalized() * drag * drag_coefficient * 0.01 * delta
	lost_velocity= lost_velocity - velocity.length()
	#print(lost_velocity)

	if enable_lift: #and ( is_zero_approx(top_speed) or get_forward_speed() < top_speed ):
		var lift: float= get_lift()
		var lift_vector:= -global_transform.y.rotated(-deg_to_rad(back_lift_angle))
		#lift_vector.x= max(0, lift_vector.x)
		#velocity+= lift_vector * lift * delta
		arcade_ratio= lift * 0.0004
	
	if propulsion_active:
		arcade_ratio= 1.0
		
	arcade_ratio= clampf(arcade_ratio, 0.0, 1.0)
	arcade_ratio= pow(arcade_ratio, 2)

	#print(arcade_ratio)

	velocity= lerp(velocity, global_transform.x * velocity.length(), arcade_ratio)
	audio_wind.volume_linear= clampf(sqrt(velocity.length()) * 0.01, 0, 1)

	var prev_y: float= position.y
	if move_and_collide(velocity * delta):
		land()
		return
	
	if position.x < 0:
		LevelManager.goto_shop()
		return
	
	# enable lift calculations as soon as we're dropping or flying level
	if prev_y < position.y or rotation > 0:
		enable_lift= true
	
	var rot_inp= Input.get_axis("rotate_left", "rotate_right")
	if not is_zero_approx(rot_inp):
		if sign(current_rotation_speed) != sign(rot_inp):
			current_rotation_speed= 0
		current_rotation_speed= move_toward(current_rotation_speed, rot_inp * rotation_speed, rotation_acceleration * delta)
	else:
		current_rotation_speed= move_toward(current_rotation_speed, 0, rotation_acceleration * delta)
	
	rotate(current_rotation_speed * delta)


# Adds all equipped upgrade overlays 
func add_upgrade_overlays():
	if test_flight:
		return

	upgrade_overlays= Node2D.new()
	add_child(upgrade_overlays)
	
	for upgrade in stats.upgrade_slots:
		if upgrade and upgrade is PonyUpgrade:
			# Add visual of the upgrade to the flying pony
			if upgrade.overlay_scene:
				var overlay: Node2D= upgrade.overlay_scene.instantiate()
				# If the scene contains a custom script initialize it
				# with the reference to our flying pony
				if overlay is UpgradeOverlayScene:
					overlay.init(self)
				upgrade_overlays.add_child(overlay)


func remove_upgrade_overlays():
	if test_flight:
		return

	upgrade_overlays.queue_free()


func activate_head(head: Sprite2D):
	if test_flight:
		return
	head_idle.hide()
	head_flying.hide()
	head_running.hide()
	head.show()


func play_animation():
	if test_flight:
		return

	if idle_sprite:
		idle_sprite.hide()
	if animated_run_sprite:
		animated_run_sprite.hide()
	if animated_flight_sprite:
		animated_flight_sprite.hide()
	
	match state:
		State.WALKING:
			if animated_run_sprite:
				animated_run_sprite.show()
				var anim_name:= "run"
				var upgrade: PonyUpgrade= stats.get_upgrade(ShopUpgrade.Category.PROPULSION)
				if upgrade and upgrade.custom_walk_animation:
					anim_name= upgrade.custom_walk_animation
				animated_run_sprite.play(anim_name)
			activate_head(head_running)

		State.FLYING:
			if animated_flight_sprite:
				animated_flight_sprite.show()
				var anim_name:= "fly"
				var upgrade: PonyUpgrade= stats.get_upgrade(ShopUpgrade.Category.PROPULSION)
				if upgrade and upgrade.custom_flight_animation:
					anim_name= upgrade.custom_flight_animation
				animated_flight_sprite.play(anim_name)
			activate_head(head_flying)
		_:
			idle_sprite.show()


func get_drag()-> float:
	var optimal_drag: float= stats.get_stat_value(PonyStats.StatType.DRAG)
	var dot: float= global_transform.x.dot(velocity.normalized())

	var drag_factor: float= clampf(pow(dot, 8), 0.0, 1.0)
	return lerp(maximum_drag, optimal_drag, drag_factor)


func get_lift()-> float:
	var maximum_lift: float= stats.get_stat_value(PonyStats.StatType.LIFT)
	maximum_lift= sqrt(maximum_lift) * .25
	
	var dot: float= global_transform.x.dot(velocity.normalized())
	var dir_lift: float=lerp(0.0, maximum_lift, max(0, pow(dot, 23)))
	return dir_lift * velocity.length_squared() * 0.0003


func get_speed()-> float:
	return velocity.length()


func get_forward_speed()-> float:
	return max(0, velocity.dot(global_transform.x))


func get_height()-> float:
	return abs(position.y - orig_pos.y)


func get_distance()-> float:
	return max(0, position.x - (orig_pos.x + walk_distance)) 


func get_fuel_ratio()-> float:
	var max_fuel: float= stats.get_stat_value(PonyStats.StatType.FUEL)
	if is_zero_approx(max_fuel):
		return 0
	return remaining_fuel / max_fuel
