extends CanvasLayer

@export var launch_scene: PackedScene
@export var pony_stats: PonyStats



func _on_texture_button_launch_pressed() -> void:
	get_tree().change_scene_to_packed(launch_scene)


func _on_texture_button_fuel_pressed() -> void:
	pass # Replace with function body.
