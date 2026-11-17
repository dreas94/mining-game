@tool
class_name BodyPartTorso
extends BodyPart

@export var torso_sprite: Sprite2D

@export var arm_connection_position_left: Vector2:
	set(value):
		if _body.arms == null:
			return
		_arm_connection_position_left = value
		_body.arms.arm_left.position = _arm_connection_position_left
	get():
		return _arm_connection_position_left
@export var arm_connection_position_right: Vector2:
	set(value):
		if _body.arms == null:
			return
		_arm_connection_position_right = value
		_body.arms.arm_right.position = _arm_connection_position_left
	get():
		return _arm_connection_position_right
@export var legs_connection_position_right: Vector2:
	set(value):
		if _body.legs == null:
			return
		_legs_connection_position_right = value
		_body.legs.leg_right.position = legs_connection_position_right
	get():
		return _legs_connection_position_right
@export var legs_connection_position_left: Vector2:
	set(value):
		if _body.legs == null:
			return
		_legs_connection_position_left = value
		_body.legs.leg_left.position = _legs_connection_position_left
	get():
		return _legs_connection_position_left
@export var head_connection_position: Vector2:
	set(value):
		if _body.head == null:
			return
		_head_connection_position = value
		_body.head.position = _head_connection_position
	get():
		return _head_connection_position

var _arm_connection_position_left: Vector2 = Vector2.ZERO
var _arm_connection_position_right: Vector2 = Vector2.ZERO
var _legs_connection_position_left: Vector2 = Vector2.ZERO
var _legs_connection_position_right: Vector2 = Vector2.ZERO
var _head_connection_position: Vector2 = Vector2.ZERO
