class_name UpgradeOverlayScene
extends Node2D
## Optional base class for overlay scenes which require unique functionality
## Needs to be inherited! 

var pony: FlyingPony


func init(_pony: FlyingPony):
	pony= _pony
