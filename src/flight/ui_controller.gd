extends CanvasLayer

#a multiplier for how quickly the meter raises vv
@export var raise_speed_pixels_per_unit: float = 0.5
#activates the ui functionality incase we need to disable it at all vv
@export var active: bool = true
@export var player_ref: FlyingPony
@export var arrow: TextureRect
@export var height: TextureRect

@export var speed_min: float = 0.0
@export var speed_max: float = 1200.0
#minimum clamp vv
@export var sweep_min_deg: float = 0.0
#max clamp vv
@export var sweep_max_deg: float = 180.0
@export var speed_smooth_speed: float = 480.0

@export var fuel_progress_bar: TextureProgressBar


var default_height_y: float = 0.0
var start_player_y: float = 0.0
var zero_angle_deg: float = 0.0
var top_speed: float



func _ready() -> void:

	EventChannel.run_ended.connect(_run_ended)

	if height:
		default_height_y = height.position.y
	if is_instance_valid(player_ref):
		start_player_y = player_ref.global_position.y
	if arrow:
		zero_angle_deg = arrow.rotation_degrees

	top_speed= player_ref.stats.get_stat_value(PonyStats.StatType.TOP_SPEED)
	%Speedlimit.visible= top_speed > 0


func _process(delta: float) -> void:
	if active and is_instance_valid(player_ref):
		_update_height_meter()
		_update_speedometer(delta)
		_update_fuel_display()


func _update_height_meter() -> void:
	#takes the ground height and adjusts heitgh bar based on the difference in players y pos vv
	var altitude_units = start_player_y - player_ref.global_position.y
	var pixel_offset = altitude_units * raise_speed_pixels_per_unit
	height.position.y = default_height_y - -pixel_offset


func _update_speedometer(delta: float) -> void:
	if arrow == null:
		return

	var speed = abs(player_ref.velocity.length())
	var clamped_speed = clamp(speed, speed_min, speed_max)
	#converts speed from 0 to max for the speedometers angle vv
	var sweep = remap(clamped_speed, speed_min, speed_max, sweep_min_deg, sweep_max_deg)
	var target_angle = zero_angle_deg + sweep

	arrow.rotation_degrees = move_toward(arrow.rotation_degrees, target_angle, speed_smooth_speed * delta)

	if top_speed > 0:
		%Speedlimit.value= player_ref.get_forward_speed() / top_speed


func _update_fuel_display():
	fuel_progress_bar.value= player_ref.get_fuel_ratio()


func _run_ended() -> void:
	$UIAnim.play("display_results")
