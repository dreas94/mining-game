@tool
class_name BodyPart
extends Node2D

var id: String
var _body: Body


func _ready() -> void:
	if not get_parent() is Body:
		return
	_body = get_parent()


func setup_body_part(_dict: Dictionary) -> void:
	pass
