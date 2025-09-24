extends Node

const START = preload("res://start_menu/start_menu.tscn")
const SHOP = preload("res://shop/shop.tscn")
const FLIGHT = preload("res://flight/flight_scene.tscn")

func _load_level(level: PackedScene) -> void:
	if level == null:
		push_error("No scene is available for the requested level (null PackedScene).")
		return

	var current = get_tree().current_scene

	if is_instance_valid(current):
		var curr_path = current.scene_file_path
		var next_path = level.resource_path
		if curr_path == next_path:
			push_warning("Requested scene is the same as the current one: " + curr_path)
			return

	call_deferred("_change_scene", level)

func _change_scene(level: PackedScene) -> void:
	get_tree().change_scene_to_packed(level)
