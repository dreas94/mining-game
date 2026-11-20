@tool
class_name BodyPartArms
extends BodyPart

@export var arm_left: Sprite2D
@export var arm_right: Sprite2D

@export var torso_connection_left: Vector2:
	set(value):
		if arm_left == null:
			return
		_torso_connection_left = value
		arm_left.offset = value
	get():
		return _torso_connection_left
@export var torso_connection_right: Vector2:
	set(value):
		if arm_right == null:
			return
		_torso_connection_right = value
		arm_right.offset = value
	get():
		return _torso_connection_right

var _torso_connection_left: Vector2 = Vector2.ZERO
var _torso_connection_right: Vector2 = Vector2.ZERO


func _ready() -> void:
	super()
	torso_connection_left = _torso_connection_left
	torso_connection_right = _torso_connection_right
	print("arms is ready")


func setup_body_part(dict: Dictionary[String, Variant]) -> void:
	super(dict)
	arm_left = dict["sprite_left"]
	arm_right = dict["sprite_right"]
	torso_connection_left = dict["torso_connection_left"]
	torso_connection_right = dict["torso_connection_right"]
