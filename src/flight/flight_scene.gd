extends Node2D

@export var player: CharacterBody2D
@export var pause_time: float = 3.0
@export var pixels_per_meter: float = 32.0

var _waiting: bool = false
var travel_distance_px: float = 0.0
var default_x_pos: float
var default_y_pos: float
var max_height_px: float = 0.0
var _last_displayed_meters: int = -1

func _ready() -> void:
	default_x_pos = player.global_position.x
	default_y_pos = player.global_position.y

func _process(_delta: float) -> void:
	if !_waiting and player.velocity.length() <= 0.05:
		_waiting = true
		await get_tree().create_timer(pause_time).timeout
		if player.velocity.length() <= 0.05:
			var distance_m = int(roundi(abs(travel_distance_px) / pixels_per_meter))
			var height_m = int(roundi(max_height_px / pixels_per_meter))
			var money_earned = int(roundi((distance_m + height_m) / 2.0))
			run_ended(money_earned)

	travel_distance_px = player.global_position.x - default_x_pos
	var meters = int(roundi(abs(travel_distance_px) / pixels_per_meter))

	var height_above_start_px = max(0.0, default_y_pos - player.global_position.y)
	if height_above_start_px > max_height_px:
		max_height_px = height_above_start_px

	if meters != _last_displayed_meters:
		_last_displayed_meters = meters
		$UI/Distancelbl.text = "Distance - " + str(meters) + "m"

func run_ended(money_earned: int) -> void:
	Global.add_currency(money_earned)
	print(str(money_earned), " money earned!")
	EventChannel.run_ended.emit()
	update_results()

func update_results() -> void:
	var distance_m = int(roundi(abs(travel_distance_px) / pixels_per_meter))
	var height_m = int(roundi(max_height_px / pixels_per_meter))
	var money_earned = int(roundi((distance_m + height_m) / 2.0))

	$UI/Results/VBoxContainer/Distlbl.text = "Distance: " + str(distance_m) + "m"
	$UI/Results/VBoxContainer/Heightlbl.text = "Max Height: " + str(height_m) + "m"
	$UI/Results/VBoxContainer/Moneylbl.text = "Money Earned: $" + str(money_earned)

func _on_return_pressed() -> void:
	LevelManager.goto_shop()
