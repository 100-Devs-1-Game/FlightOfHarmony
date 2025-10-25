extends Node2D

@export var ui_buttons: Array[BaseButton] = []

@onready var tutorial: Control = %Tutorial



func _ready() -> void:
	#if we add a quit button to win/lin exports this will hide it in the future
	#we just need to make sure its spelt "Quit"
	if OS.has_feature("web"):
		for i in ui_buttons:
			if i.name == "Quit":
				i.visible = false

	#loop through and connect the press signal sending its name
	for button in ui_buttons:
		button.pressed.connect(_on_button_pressed.bind(button.name))


func _on_button_pressed(action: StringName) -> void:
	match action: #bases them off their names, we can change it later though!
		"Start":
			LevelManager.goto_shop()
		"Settings":
			pass


func _on_reset_pressed() -> void:
	SaveManager.pony_stats.reset_all_upgrades()
	SaveManager.reset()
	Global.reset()
	EventChannel.reset_progress.emit()


func _on_tutorial_pressed() -> void:
	tutorial.open()
