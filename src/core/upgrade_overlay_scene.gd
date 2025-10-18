class_name UpgradeOverlayScene
extends Node2D
## Optional base class for overlay scenes which require unique functionality

@export var running_node: Node2D
@export var flying_node: Node2D

var pony: FlyingPony



func init(_pony: FlyingPony):
	pony= _pony
	await ready
	assert(running_node == null or ( running_node != flying_node ))

	if running_node:
		running_node.show()
		flying_node.hide()

	if flying_node:
		pony.started_flying.connect(func():
			if running_node:
				running_node.hide()
			flying_node.show())
