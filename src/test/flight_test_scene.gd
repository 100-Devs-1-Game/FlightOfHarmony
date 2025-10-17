extends Node2D

@export var num_clouds: int= 100
@export var cloud_step: int= 50
@export var max_cloud_height: int= 5000



func _ready() -> void:
	SaveManager.disabled= true


func _draw() -> void:
	var color:= Color.WHITE
	color.a= 0.5
	
	for i in num_clouds:
		draw_rect(Rect2(i * cloud_step, randf_range(-max_cloud_height, 500), 100, 30), color)
