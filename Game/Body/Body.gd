@tool
class_name Body
extends Node2D

@export var head: BodyPartHead
@export var arms: BodyPartArms
@export var legs: BodyPartLegs
@export var torso: BodyPart

@export var arm_connection_position_left: Vector2:
	set(value):
		_arm_connection_position_left = value
	get():
		return _arm_connection_position_left
@export var arm_connection_position_right: Vector2:
	set(value):
		_arm_connection_position_right = value
	get():
		return _arm_connection_position_right
@export var legs_connection_position_right: Vector2:
	set(value):
		_legs_connection_position_right = value
		legs.leg_right.position = legs_connection_position_right
	get():
		return _legs_connection_position_right
@export var legs_connection_position_left: Vector2:
	set(value):
		_legs_connection_position_left = value
		legs.leg_left.position = _legs_connection_position_left
	get():
		return _legs_connection_position_left
@export var head_connection_position: Vector2:
	set(value):
		_head_connection_position = value
	get():
		return _head_connection_position

var _arm_connection_position_left: Vector2 = Vector2.ZERO
var _arm_connection_position_right: Vector2 = Vector2.ZERO
var _legs_connection_position_left: Vector2 = Vector2.ZERO
var _legs_connection_position_right: Vector2 = Vector2.ZERO
var _head_connection_position: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	head.physics_update(delta)
	torso.physics_update(delta)
	arms.physics_update(delta)
	legs.physics_update(delta)
