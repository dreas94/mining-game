@tool
class_name BodyPart
extends Node2D

var id: String
var _body: iBody


func _ready() -> void:
	if not get_parent() is iBody:
		return
	_body = get_parent()


func body_part_flip_h(_value: bool) -> void:
	pass
