@tool
class_name AnimatedPointLight2D
extends PointLight2D

@export_category("Animation")
@export var flicker_enabled: bool = false:
	set(value):
		flicker_enabled = value
		if flicker_enabled:
			_start_flicker_tween()
		else:
			_stop_flicker_tween()
@export var duration_per_flicker_update: float = 0.5
@export var flicker_range: float = 0.2
@export var base_energy: float = 1.0:
	set(value):
		var delta: float = base_energy - value
		base_energy = value
		if flicker_enabled:
			energy = energy - delta
		else:
			energy = base_energy
@export var scaler_enabled: bool = true:
	set(value):
		scaler_enabled = value
		if scaler_enabled:
			_start_scale_tween()
		else:
			_stop_scale_tween()
			
@export var duration_per_scale_update: float = 0.25
@export var scale_range: float = 0.2
@export var base_scale: float = 1.0:
	set(value):
		var delta: float = base_scale - value
		base_scale = value
		if scaler_enabled:
			texture_scale = texture_scale - delta
		else:
			texture_scale = base_scale

var _flicker_tween: Tween
var _scale_tween: Tween


func _ready() -> void:
	energy = base_energy
	texture_scale = base_scale
	if flicker_enabled:
		_start_flicker_tween()
	
	if scaler_enabled:
		_start_scale_tween()


func _start_scale_tween() -> void:
	if _scale_tween != null and _scale_tween.is_running():
		_scale_tween.stop()
		_scale_tween = null
	
	_scale_tween = create_tween()
	_scale_tween.set_loops()
	_scale_tween.tween_callback(_scaler)
	_scale_tween.tween_interval(duration_per_scale_update)


func _stop_scale_tween() -> void:
	if _scale_tween == null:
		return
	if not _scale_tween.is_running():
		return
	_scale_tween.stop()
	_scale_tween = null


func _start_flicker_tween() -> void:
	if _flicker_tween != null and _flicker_tween.is_running():
		_flicker_tween.stop()
		_flicker_tween = null
	
	_flicker_tween = create_tween()
	_flicker_tween.set_loops()
	_flicker_tween.tween_callback(_flicker)
	_flicker_tween.tween_interval(duration_per_flicker_update)


func _stop_flicker_tween() -> void:
	if _flicker_tween == null:
		return
	if not _flicker_tween.is_running():
		return
	_flicker_tween.stop()
	_flicker_tween = null


func _flicker() -> void:
	var random_energy: float = randf_range(-flicker_range, flicker_range)
	energy = base_energy + random_energy


func _scaler() -> void:
	var random_scale: float = randf_range(-scale_range, scale_range)
	texture_scale = base_scale + random_scale


func _exit_tree() -> void:
	if flicker_enabled and _flicker_tween != null and _flicker_tween.is_running():
		_flicker_tween.kill()
		_flicker_tween = null
	
	if scaler_enabled and _scale_tween != null and _scale_tween.is_running():
		_scale_tween.kill()
		_scale_tween = null
