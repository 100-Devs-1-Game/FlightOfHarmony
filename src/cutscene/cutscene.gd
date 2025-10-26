extends CanvasLayer

@export var frames_per_second: float= .25
@export var fade_duration: float= 0.1
@export var follow_scene: PackedScene

@export var images: Array[Texture2D]

@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2

var index: int= 1



func _ready() -> void:
	run.call_deferred()


func run():
	var interval: float= 1.0 / frames_per_second
	texture_rect.texture= images[0]
	texture_rect_2.texture= images[1]

	await get_tree().create_timer(interval).timeout

	for i in images.size() - 2:
		index+= 1
		swap()
		await get_tree().create_timer(interval).timeout
		update_textures()

	await get_tree().create_timer(interval).timeout
	index+= 1
	swap()
	await get_tree().create_timer(interval).timeout
	
	if follow_scene:
		get_tree().change_scene_to_packed(follow_scene)


func update_textures():
	if index % 2 == 0:
		texture_rect.texture= images[index]
	else:
		texture_rect_2.texture= images[index]


func swap():
	var from: TextureRect
	var to: TextureRect

	if index % 2 == 0:
		from= texture_rect
		to= texture_rect_2
	else:
		from= texture_rect_2
		to= texture_rect

	var tween:= create_tween()
	tween.tween_property(from, "modulate", Color.TRANSPARENT, fade_duration * 5)
	to.modulate.a= 1
	tween.parallel().tween_property(to, "modulate", Color.WHITE, fade_duration)
