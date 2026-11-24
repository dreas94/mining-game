@tool
class_name BodyPartHead
extends BodyPart

@export var head_sprite: Sprite2D

@export var torso_connection: Vector2:
	set(value):
		if head_sprite == null:
			return
		_torso_connection = value
		head_sprite.offset = value
	get():
		return _torso_connection

var _torso_connection: Vector2 = Vector2.ZERO


func _ready() -> void:
	super()
	_torso_connection = torso_connection
	print("head is ready")


func setup_body_part(id_string: String, texture: Texture2D, pos: Vector2) -> void:
	id = id_string
	head_sprite.texture = texture
	torso_connection = pos


func body_part_flip_h(value: bool) -> void:
	if head_sprite.flip_h == value:
		return
	
	_body.torso.head_connection_position *= -1
	head_sprite.flip_h = value
