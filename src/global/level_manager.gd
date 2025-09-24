extends Node

const START_PATH := "res://start_menu/start_menu.tscn"
const SHOP_PATH := "res://shop/shop.tscn"
const FLIGHT_PATH := "res://flight/flight_scene.tscn"

func load_level_by_path(path: String) -> void:
	var scene := load(path) as PackedScene
	if scene == null:
		push_error("LevelManager: failed to load scene at: " + path)
		return
	_change_to(scene)

func goto_start() -> void:
	load_level_by_path(START_PATH)

func goto_shop() -> void:
	load_level_by_path(SHOP_PATH)

func goto_flight() -> void:
	load_level_by_path(FLIGHT_PATH)

func _change_to(packed: PackedScene) -> void:
	var current = get_tree().current_scene
	if is_instance_valid(current):
		var curr_path = current.scene_file_path
		var next_path = packed.resource_path
		if curr_path == next_path:
			push_warning("LevelManager: requested scene is already active: " + curr_path)
			return
	call_deferred("_do_change", packed)

func _do_change(packed: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed)
