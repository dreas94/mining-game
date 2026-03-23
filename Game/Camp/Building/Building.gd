@tool
class_name iBuilding
extends Node2D
signal player_entered
signal player_exited

@export var sprite_texture: Texture2D:
	set(new_texture):
		_sprite_texture = new_texture
	get:
		return _sprite_texture
@export var polygon: PackedVector2Array = []:
	set(value):
		polygon = value.duplicate()
		if _collision_polygon == null:
			return
		_collision_polygon.polygon = polygon
@export var area_2d: Area2D
@export var _collision_polygon: CollisionPolygon2D
@export var _sprite: Sprite2D


var _sprite_texture: Texture2D:
	set(new_texture):
		_sprite_texture = new_texture
		_sprite.texture = new_texture

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered_area_2d)
	area_2d.body_exited.connect(_on_body_exited_area_2d)
	_sprite.texture = sprite_texture


func _on_body_entered_area_2d(body: Node2D) -> void:
	if not body is iPlayer:
		return
	
	player_entered.emit()


func _on_body_exited_area_2d(body: Node2D) -> void:
	if not body is iPlayer:
		return
	
	player_exited.emit()
