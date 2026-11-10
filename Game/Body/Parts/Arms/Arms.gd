@tool
class_name BodyPartArms
extends BodyPart

@export var arm_left: Sprite2D
@export var arm_right: Sprite2D

@export var torso_connection_left: Vector2:
	set(value):
		_torso_connection_left = value
		arm_left.offset = value
	get():
		return _torso_connection_left
@export var torso_connection_right: Vector2:
	set(value):
		_torso_connection_right = value
		arm_right.offset = value
	get():
		return _torso_connection_right

var _torso_connection_left: Vector2 = Vector2.ZERO
var _torso_connection_right: Vector2 = Vector2.ZERO
