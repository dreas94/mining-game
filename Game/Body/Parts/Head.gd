@tool
class_name BodyPartHead
extends BodyPart

@export var head_sprite: Sprite2D

@export var torso_connection: Vector2:
	set(value):
		if head_sprite == null:
			return
		_torso_connection = value
	get():
		return _torso_connection

var _torso_connection: Vector2 = Vector2.ZERO


func setup_body_part(dict: Dictionary[String, Variant]) -> void:
	id = dict[id]
	head_sprite = dict["sprite"]
	torso_connection = dict["torso_connection"]
