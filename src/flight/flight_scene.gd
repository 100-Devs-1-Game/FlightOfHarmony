extends Node2D

@export var player: CharacterBody2D
@export var win_distance: float= 250000
@export var win_height: float= 45000
@export var clouds_fade_min_height: float= 2000.0
@export var clouds_fade_max_height: float= 3000.0

@onready var foreground_clouds: Parallax2D = %"Foreground Clouds"
@onready var springboard: AnimatedSprite2D = $"AnimatedSprite Springboard"

var _max_height: float = 0.0


func _ready() -> void:
	if player != null:
		player.connect("landed", Callable(self, "_on_player_landed"))


func _process(_delta: float) -> void:
	if player == null:
		return

	if Input.is_action_just_pressed("ui_cancel"):
		LevelManager.goto_shop()
		return

	var distance_m = int(roundi(player.get_distance())) / 100
	%Distancelbl.text = "Distance - " + str(distance_m) + "m"

	var h = max(0.0, player.get_height())
	if h > _max_height:
		_max_height = h

	var weight:= clampf((h - clouds_fade_min_height) / (clouds_fade_max_height - clouds_fade_min_height), 0.0, 1.0)
	foreground_clouds.modulate.a= lerp(0.0, 0.75, weight)


func _physics_process(_delta: float) -> void:
	if player.get_distance() > win_distance or player.get_height() > win_height:
		LevelManager.goto_end()


func _on_player_landed() -> void:
	if player == null:
		return

	var distance_m = int(roundi(player.get_distance())) / 100
	var height_m = int(roundi(_max_height)) / 100
	var money_earned: int = max(0, roundi((distance_m + height_m) * 0.5))
	var interest_rate: float= get_interest_rate()
	var bonus: int= money_earned * interest_rate

	%Distlbl.text = str(distance_m) + "m"
	%Heightlbl.text = str(height_m) + "m"
	%Moneylbl.text = str("$", money_earned)
	if interest_rate > 0:
		%Bonuslbl.text = str("$", bonus)
	%Totallbl.text = str("$", money_earned + bonus)
	
	run_ended(money_earned + bonus)

	_max_height = 0.0


func run_ended(money_earned: int) -> void:
	Global.add_currency(money_earned)
	print(str(money_earned), " money earned!")
	EventChannel.run_ended.emit()
	#update_results()


func get_interest_rate()-> float:
	var interest:= 0
	for upgrade in SaveManager.bought_upgrades:
		if upgrade is MoneyUpgrade:
			interest= max(interest, upgrade.bonus)
	return interest / 100.0


func _on_return_pressed() -> void:
	Global.day+= 1
	LevelManager.goto_shop()


func _on_springboard_body_entered(_body: Node2D) -> void:
	springboard.play("default")
