extends PanelContainer

@export var stats: PonyStats
@export var stat: PonyStats.StatType
@export var slider_scene: PackedScene
@export var label_settings: LabelSettings

@onready var hbox: HBoxContainer = $MarginContainer/HBoxContainer

var level_label:= Label.new()



func _ready():
	var label:= Label.new()
	label.text= stats.get_stat(stat).display_name
	label.custom_minimum_size.x= 200
	label.label_settings= label_settings
	hbox.add_child(label)
	
	var slider: HSlider= slider_scene.instantiate()
	slider.value_changed.connect(on_slider_changed)
	hbox.add_child(slider)
	
	level_label.custom_minimum_size.x= 50
	level_label.label_settings= label_settings
	update_level_label()
	hbox.add_child(level_label)

	await get_tree().process_frame
	slider.scale.y= 2


func update_level_label():
	level_label.text= str(stats.get_level(stat))
	

func on_slider_changed(value: float):
	stats.set_level(stat, int(value), false)
	update_level_label()
