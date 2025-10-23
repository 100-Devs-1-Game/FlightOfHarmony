class_name ThrustParticles
extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	set_active(false)


func set_active(b: bool):
	particles.emitting= b
