@tool
class_name BodyPartLegs
extends BodyPart

@export var leg_right: Sprite2D
@export var leg_left: Sprite2D

@export var torso_connection_left: Vector2:
	set(value):
		if leg_left == null:
			return
		_torso_connection_left = value
		leg_left.offset = value
	get():
		return _torso_connection_left
@export var torso_connection_right: Vector2:
	set(value):
		if leg_right == null:
			return
		_torso_connection_right = value
		leg_right.offset = value
	get():
		return _torso_connection_right

var _torso_connection_left: Vector2 = Vector2.ZERO
var _torso_connection_right: Vector2 = Vector2.ZERO


func _ready() -> void:
	super()
	torso_connection_left = _torso_connection_left
	torso_connection_right = _torso_connection_right
	print("legs is ready")


func setup_body_part(id_string: String, texture_left: Texture2D, texture_right: Texture2D, connection_left: Vector2, connection_right: Vector2) -> void:
	id = id_string
	leg_left.texture = texture_left
	leg_right.texture = texture_right
	torso_connection_left = connection_left
	torso_connection_right = connection_right


func body_part_flip_h(value: bool) -> void:
	if leg_right.flip_h == value:
		return
	if leg_left.flip_h == value:
		return
	
	_body.torso.arm_connection_position_right.x *= -1
	leg_right.flip_h = value
	_body.torso.arm_connection_position_left.x *= -1
	leg_left.flip_h = value
