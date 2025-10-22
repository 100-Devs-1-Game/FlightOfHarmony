extends CanvasLayer

@onready var audio_player_shop: AudioStreamPlayer = $"AudioStreamPlayer Shop"
@onready var audio_player_flight: AudioStreamPlayer = $"AudioStreamPlayer Flight"


func _ready() -> void:
	audio_player_shop.play()


func switch():
	var source_player: AudioStreamPlayer= audio_player_shop if audio_player_shop.playing else audio_player_flight
	var target_player: AudioStreamPlayer= audio_player_shop if source_player == audio_player_flight else audio_player_flight

	var tween:= create_tween()
	var duration:= 1.0
	tween.parallel().tween_property(source_player, "volume_linear", 0.0, duration)
	target_player.volume_linear= 0.0
	target_player.play()
	tween.tween_property(target_player, "volume_linear", 1.0, duration)
	tween.tween_callback(func(): source_player.stop())


func _on_texture_button_toggled(toggled_on: bool) -> void:
	var bus= AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, toggled_on)
