@tool
class_name BodyPartLegs
extends BodyPart

@export var leg_left: Sprite2D
@export var leg_right: Sprite2D

@export var torso_connection_left: Vector2:
	set(value):
		_torso_connection_left = value
		leg_left.offset = value
	get():
		return _torso_connection_left
@export var torso_connection_right: Vector2:
	set(value):
		_torso_connection_right = value
		leg_right.offset = value
	get():
		return _torso_connection_right

var _torso_connection_left: Vector2 = Vector2.ZERO
var _torso_connection_right: Vector2 = Vector2.ZERO
