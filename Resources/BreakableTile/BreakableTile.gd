class_name BreakableTile
extends Node2D
signal broken

var size: Vector2
var visual: ColorRect = ColorRect.new()
var health: IntAttribute = IntAttribute.new(100, 100)

var _tween: Tween
var _color_multiplier: float

func _init(tile_size: Vector2, global_pos: Vector2) -> void:
	size = tile_size
	global_position = global_pos
	


func _ready() -> void:
	health.changed.connect(_on_health_changed)
	add_child(visual)
	visual.size = size
	visual.position = Vector2(-size.x * 0.5, -size.x * 0.5)
	visual.color = Color(0.0, 0.0, 0.0, 0.0)
	visual.material = load("uid://c1nkj436djpxy").duplicate()
	visual.material.set("shader_parameter/crack_depth", 1.0)
	visual.material.set("shader_parameter/crack_scale", 4.0)
	visual.material.set("shader_parameter/crack_zebra_scale", 2.67)
	visual.material.set("shader_parameter/crack_zebra_amp", 0.0)
	visual.material.set("shader_parameter/crack_profile", 0.45)
	visual.material.set("shader_parameter/crack_slope", 11.0)
	visual.material.set("shader_parameter/crack_width", 0.0)
	visual.material.set("shader_parameter/crack_alpha", 0.75)
	visual.material.set("shader_parameter/custom_crack_color", Vector4(0.0, 0.0, 0.0, 1.0))


func _physics_process(delta: float) -> void:
	_color_multiplier = lerpf(_color_multiplier, 0.0, 0.25 * delta)
	var new_shader_param_color: Vector4 = Vector4(_color_multiplier, _color_multiplier, _color_multiplier, 1.0)
	set_shader_param_color(new_shader_param_color)


func _on_health_changed(value: int, _delta: int) -> void:
	if value == 0:
		return
	var remapped_value: float = remap(float(value), 100.0, 0.0, 0.0, 0.1)
	_color_multiplier = lerpf(_color_multiplier, 2.0, 1.0)
	var new_shader_param_color: Vector4 = Vector4(_color_multiplier, _color_multiplier, _color_multiplier, 1.0)
	set_shader_param_color(new_shader_param_color)
	set_shader_param_crack_width(remapped_value)
	


func get_shader_param_color() -> Vector4:
	return visual.material.get("shader_parameter/custom_crack_color")


func set_shader_param_color(value: Vector4) -> void:
	visual.material.set("shader_parameter/custom_crack_color", value)


func set_shader_param_crack_width(value: float) -> void:
	visual.material.set("shader_parameter/crack_width", value)


func _check_health() -> void:
	if health.value > 0.0:
		return
	
	_tween.kill()
	
	broken.emit()
	queue_free()
