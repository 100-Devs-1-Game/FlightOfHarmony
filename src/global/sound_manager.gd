extends Node

@onready var fail: AudioStreamPlayer = $"AudioStreamPlayer Fail"
@onready var suit_up: AudioStreamPlayer = $"AudioStreamPlayer Suit Up"
@onready var button_click: AudioStreamPlayer = $"AudioStreamPlayer Button Click"
@onready var button_hover: AudioStreamPlayer = $"AudioStreamPlayer Button Hover"



func _ready() -> void:
	get_tree().node_added.connect(on_node_added)


func on_node_added(node: Node):
	if node is BaseButton:
		var button: BaseButton= node
		button.mouse_entered.connect(func():
			button_hover.play())
