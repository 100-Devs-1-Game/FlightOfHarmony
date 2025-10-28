extends UpgradeOverlayScene

@export var audio_player: AudioStreamPlayer


func _ready() -> void:
	pony.started_flying.connect(func():
		if audio_player:
			audio_player.play())
	
