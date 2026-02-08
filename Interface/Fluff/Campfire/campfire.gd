@tool
class_name CampFire
extends Node2D

@export var enabled: bool:
	set(value):
		enabled = value
		if _light_source == null:
			return
		_light_source.enabled = value
@export var light_scale: Vector2:
	get:
		return _light_scale
	set(value):
		_light_scale = value
@export var light_layer: Vector2:
	get:
		return _light_layer
	set(value):
		_light_layer = value
@export var _light_source: AnimatedPointLight2D

var _light_scale: Vector2:
	set(value):
		_light_scale = value
		if _light_source == null:
			return
		_light_source.scale = _light_scale

var _light_layer: Vector2:
	set(value):
		_light_layer = value
		if _light_source == null:
			return
		_light_source.range_layer_min = int(_light_layer.x)
		_light_source.range_layer_max = int(_light_layer.y)


func _ready() -> void:
	enabled = false
	_light_scale = _light_source.scale
