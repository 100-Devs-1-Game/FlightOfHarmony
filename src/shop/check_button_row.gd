extends Control

@export var title: String

@export var pony_stats: PonyStats
@export var stat: PonyStats.StatEnum

@onready var title_label: Label = %"Title Label"
@onready var button_container: HBoxContainer = %HBoxContainer



func _ready() -> void:
	title_label.text= title
	
	var level: int= 1
	for child: TextureButton in button_container.get_children():
		child.pressed.connect(_on_level_up.bind(level))
		level+= 1


func _on_level_up(level: int):
	pony_stats.set_level(stat, level)
	for i in level:
		(button_container.get_child(i) as TextureButton).disabled= true
		
