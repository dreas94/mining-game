@tool
class_name BodyPartHead
extends BodyPart

@export var torso_connection: Vector2:
	set(value):
		_torso_connection = value
	get():
		return _torso_connection

var _torso_connection: Vector2 = Vector2.ZERO
