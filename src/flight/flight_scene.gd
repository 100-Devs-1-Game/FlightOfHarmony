extends Node2D

@export var player: CharacterBody2D

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


func _on_player_landed() -> void:
	if player == null:
		return

	var distance_m = int(roundi(player.get_distance())) / 100
	var height_m = int(roundi(_max_height)) / 100
	var money_earned: int = int(roundi((distance_m + height_m) / 2.0))
	var bonus: int= money_earned * get_interest_rate()

	$UI/Results/VBoxContainer/Distlbl.text = "Distance: " + str(distance_m) + "m"
	$UI/Results/VBoxContainer/Heightlbl.text = "Max Height: " + str(height_m) + "m"
	var money_text:= "Earned: $" + str(money_earned)
	if bonus > 0:
		money_text+= " (+$%d)" % str(bonus)
	$UI/Results/VBoxContainer/Moneylbl.text = money_text
	
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
	return 1 + interest / 100.0


func _on_return_pressed() -> void:
	LevelManager.goto_shop()
