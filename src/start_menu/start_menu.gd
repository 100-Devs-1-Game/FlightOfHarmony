extends Node2D

@export var ui_buttons: Array[BaseButton] = []
@export var credits_scene: PackedScene

@onready var tutorial: Control = %Tutorial


func _ready() -> void:
	if not MusicPlayer.is_playing():
		MusicPlayer.audio_player_shop.play()
		

func _on_reset_pressed() -> void:
	SaveManager.pony_stats.reset_all_upgrades()
	SaveManager.reset()
	Global.reset()
	EventChannel.reset_progress.emit()
	LevelManager.goto_shop()


func _on_tutorial_pressed() -> void:
	tutorial.open()


func _on_start_pressed() -> void:
	LevelManager.goto_shop()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(credits_scene)
