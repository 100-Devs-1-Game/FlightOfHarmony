class_name FlightBackground
extends CanvasLayer

@export var parallax_nodes: Array[Parallax2D]



func scroll(delta: float):
	for node in parallax_nodes:
		node.scroll_offset.x-= delta
		print(delta)
