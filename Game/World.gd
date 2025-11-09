extends Node2D

@export var player: iPlayer

func _ready() -> void:
	player.global_position.y = -BlockConstants.SIZE.y
