class_name BodyPart
extends Node2D

var id: String
var texture: Texture2D
var _pda: BodyPDA


func physics_update(delta: float) -> void:
	_pda.physics_update(delta)
