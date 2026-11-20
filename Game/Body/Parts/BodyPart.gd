@tool
class_name BodyPart
extends Node2D

var id: String
var _body: iBody


func _ready() -> void:
	if not get_parent() is iBody:
		return
	_body = get_parent()


func setup_body_part(dict: Dictionary[String, Variant]) -> void:
	id = dict["id"]


func body_part_flip_h(value: bool) -> void:
	scale.x = 1.0 if value == false else -1.0
