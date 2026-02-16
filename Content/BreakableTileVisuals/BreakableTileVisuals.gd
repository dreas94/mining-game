class_name BreakableTileVisuals
extends Node2D

@export var _visual: ColorRect = ColorRect.new()
var _color_multiplier: float
var tile_attributes: TileAttributes


func _ready() -> void:
	tile_attributes.health.changed.connect(_on_health_changed)
	_configure()


func _configure() -> void:
	_on_health_changed(tile_attributes.health.value, 0)


func _physics_process(delta: float) -> void:
	_color_multiplier = lerpf(_color_multiplier, 0.0, 0.25 * delta)
	var new_shader_param_color: Vector4 = Vector4(_color_multiplier, _color_multiplier, _color_multiplier, 1.0)
	set_shader_param_color(new_shader_param_color)


func _on_health_changed(value: int, _delta: int) -> void:
	if value == 0:
		queue_free()
		return
	var remapped_value: float = remap(float(value), 100.0, 0.0, 0.0, 0.1)
	_color_multiplier = lerpf(_color_multiplier, 2.0, 1.0)
	var new_shader_param_color: Vector4 = Vector4(_color_multiplier, _color_multiplier, _color_multiplier, 1.0)
	set_shader_param_color(new_shader_param_color)
	set_shader_param_crack_width(remapped_value)


func get_shader_param_color() -> Vector4:
	return _visual.material.get("shader_parameter/custom_crack_color")


func set_shader_param_color(value: Vector4) -> void:
	_visual.material.set("shader_parameter/custom_crack_color", value)


func set_shader_param_crack_width(value: float) -> void:
	_visual.material.set("shader_parameter/crack_width", value)
