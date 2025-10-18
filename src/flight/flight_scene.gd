extends Node2D

@export var player: CharacterBody2D
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

	var distance_m = int(roundi(player.get_distance())) / 100
	$UI/Distancelbl.text = "Distance - " + str(distance_m) + "m"

	var h = max(0.0, player.get_height())
	if h > _max_height:
		_max_height = h

	var weight:= clampf((h - clouds_fade_min_height) / (clouds_fade_max_height - clouds_fade_min_height), 0.0, 1.0)
	foreground_clouds.modulate.a= lerp(0.0, 0.75, weight)


func _on_player_landed() -> void:
	if player == null:
		return

	var distance_m = int(roundi(player.get_distance())) / 100
	var height_m = int(roundi(_max_height)) / 100
	var money_earned: int = max(0, roundi(sqrt(distance_m + height_m) * 2))
	var interest_rate: float= get_interest_rate()
	var bonus: int= money_earned * interest_rate

	$UI/Results/VBoxContainer/Distlbl.text = "Distance: " + str(distance_m) + "m"
	$UI/Results/VBoxContainer/Heightlbl.text = "Max Height: " + str(height_m) + "m"
	$UI/Results/VBoxContainer/Moneylbl.text = "Earned: $" + str(money_earned)
	if interest_rate > 0:
		$UI/Results/VBoxContainer/Bonuslbl.text = "Bonus: $" + str(bonus)
	
	run_ended(money_earned + bonus)

	_max_height = 0.0


func run_ended(money_earned: int) -> void:
	Global.add_currency(money_earned)
	print(str(money_earned), " money earned!")
	EventChannel.run_ended.emit()
	#update_results()


#func update_results() -> void:
	#if player == null:
		#return
	#var distance_m = int(roundi(player.get_distance())) / 100
	#var height_m = int(roundi(_max_height))  / 100
	#var money_earned = int(roundi((distance_m + height_m) / 2.0))
#
	#$UI/Results/VBoxContainer/Distlbl.text = "Distance: " + str(distance_m) + "m"
	#$UI/Results/VBoxContainer/Heightlbl.text = "Max Height: " + str(height_m) + "m"
	#$UI/Results/VBoxContainer/Moneylbl.text = "Money Earned: $" + str(money_earned)


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
