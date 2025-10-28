extends UpgradeOverlayScene

@export var audio_player: AudioStreamPlayer


func _ready() -> void:
	audio_player.play()
	#pony.started_flying.connect(func():
		#if audio_player:
			#audio_player.play())
	
