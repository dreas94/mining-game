class_name BodyPartTorso
extends BodyPart

@export var torso_sprite: Sprite2D

@export var torso_position: Vector2:
	set(value):
		if torso_sprite == null:
			return
		_torso_position = value
		torso_sprite.position = value
	get():
		return _torso_position
@export var arm_connection_position_right: Vector2:
	set(value):
		if _body == null:
			return
		if _body.arms == null:
			return
		
		_arm_connection_position_right = value
		_body.arms.arm_right.position = arm_connection_position_right
	get():
		return _arm_connection_position_right
@export var arm_connection_position_left: Vector2:
	set(value):
		if _body == null:
			return
		if _body.arms == null:
			return
		_arm_connection_position_left = value
		_body.arms.arm_left.position = _arm_connection_position_left
	get():
		return _arm_connection_position_left
@export var legs_connection_position_right: Vector2:
	set(value):
		if _body == null:
			return
		if _body.legs == null:
			return
		_legs_connection_position_right = value
		_body.legs.leg_right.position = legs_connection_position_right
	get():
		return _legs_connection_position_right
@export var legs_connection_position_left: Vector2:
	set(value):
		if _body == null:
			return
		if _body.legs == null:
			return
		_legs_connection_position_left = value
		_body.legs.leg_left.position = _legs_connection_position_left
	get():
		return _legs_connection_position_left
@export var head_connection_position: Vector2:
	set(value):
		if _body == null:
			return
		if _body.head == null:
			return
		_head_connection_position = value
		_body.head.position = _head_connection_position
	get():
		return _head_connection_position

var _torso_position: Vector2 = Vector2.ZERO
var _arm_connection_position_left: Vector2 = Vector2.ZERO
var _arm_connection_position_right: Vector2 = Vector2.ZERO
var _legs_connection_position_left: Vector2 = Vector2.ZERO
var _legs_connection_position_right: Vector2 = Vector2.ZERO
var _head_connection_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	super()
	print("torso is ready")
	torso_position = _torso_position
	arm_connection_position_left = _arm_connection_position_left
	arm_connection_position_right = _arm_connection_position_right
	legs_connection_position_left = _legs_connection_position_left
	legs_connection_position_right = _legs_connection_position_right
	head_connection_position = _head_connection_position


func setup_body_part(id_string: String, texture: Texture2D, head_position: Vector2, torso_pos: Vector2, arm_position_left: Vector2, arm_position_right: Vector2, leg_position_left: Vector2, leg_position_right: Vector2) -> void:
	id = id_string
	torso_sprite.texture = texture
	torso_position = torso_pos
	head_connection_position = head_position
	arm_connection_position_left = arm_position_left
	arm_connection_position_right = arm_position_right
	legs_connection_position_left = leg_position_left
	legs_connection_position_right = leg_position_right


func body_part_flip_h(value: bool) -> void:
	if torso_sprite.flip_h == value:
		return
	
	torso_position.x *= -1
	torso_sprite.flip_h = value
