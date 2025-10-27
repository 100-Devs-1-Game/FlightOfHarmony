extends Cutscene

@export var credits_scene: PackedScene


func on_finished():
	get_tree().change_scene_to_packed(credits_scene)
