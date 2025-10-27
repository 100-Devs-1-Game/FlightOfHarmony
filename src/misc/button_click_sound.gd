class_name ButtonClickSound
extends Node


func _ready() -> void:
	var button: BaseButton= get_parent()
	assert(button)
	button.pressed.connect(func():
		SoundManager.button_click.play())
