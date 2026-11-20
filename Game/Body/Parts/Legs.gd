@tool
class_name BodyPartLegs
extends BodyPart

@export var leg_left: Sprite2D
@export var leg_right: Sprite2D

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


func setup_body_part(dict: Dictionary[String, Variant]) -> void:
	super(dict)
	leg_left = dict["sprite_left"]
	leg_right = dict["sprite_right"]
	torso_connection_left = dict["torso_connection_left"]
	torso_connection_right = dict["torso_connection_right"]
