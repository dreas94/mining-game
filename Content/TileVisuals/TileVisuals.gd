class_name TileVisuals
extends Node2D

@export var _visual: ColorRect
@export var _moused_visual: PanelContainer
@export var _graphic_sprite: Sprite2D

var _color_multiplier: float
var tile_attributes: TileAttributes
var _mining_particles_scene: PackedScene = load("uid://c73q2ndbadhko")


func _ready() -> void:
	tile_attributes.graphic.changed.connect(_set_graphic)
	tile_attributes.health.changed.connect(_set_health)
	tile_attributes.is_moused.changed.connect(_set_is_moused)
		
	_configure()


func _configure() -> void:
	_set_graphic(tile_attributes.graphic.value)
	_set_health(tile_attributes.health.value, 0)
	_set_is_moused(tile_attributes.is_moused.value, false)


func _physics_process(delta: float) -> void:
	_color_multiplier = lerpf(_color_multiplier, 0.0, 0.25 * delta)
	var new_shader_param_color: Vector4 = Vector4(_color_multiplier, _color_multiplier, _color_multiplier, 1.0)
	set_shader_param_color(new_shader_param_color)


func _set_graphic(graphic: Texture2D) -> void:
	_graphic_sprite.texture = graphic


func _set_health(value: int, _delta: int) -> void:
	if value == tile_attributes.health.maximum:
		return
	var mining_particles: iMiningParticles = _mining_particles_scene.instantiate()
	mining_particles.global_position = global_position
	Mines.add_child(mining_particles)
	if value == 0:
		queue_free()
		return
	var remapped_value: float = remap(float(value), tile_attributes.health.maximum, 0.0, 0.0, 0.1)
	_color_multiplier = lerpf(_color_multiplier, 2.0, 1.0)
	var new_shader_param_color: Vector4 = Vector4(_color_multiplier, _color_multiplier, _color_multiplier, 1.0)
	set_shader_param_color(new_shader_param_color)
	set_shader_param_crack_width(remapped_value)
	_visual.visible = true


func _set_is_moused(bool_value: bool, _previous_value: bool) -> void:
	_moused_visual.visible = bool_value


func get_shader_param_color() -> Vector4:
	return _visual.material.get("shader_parameter/custom_crack_color")


func set_shader_param_color(value: Vector4) -> void:
	_visual.material.set("shader_parameter/custom_crack_color", value)


func set_shader_param_crack_width(value: float) -> void:
	_visual.material.set("shader_parameter/crack_width", value)
