class_name FloatAttribute
extends RefCounted

signal changed(float_value: float , float_delta: float)

var value: float:
	set(new_value):
		new_value = min(new_value, maximum) if maximum != 0.0 else new_value
		var old_value: float = _value
		if new_value != old_value:
			_value = new_value
			changed.emit(new_value, -(old_value - new_value))
	get:
		return _value
var _value: float = 0.0
var maximum: float = 0.0:
	set(new_value):
		maximum = new_value
		value = value
var minimum: float = 0.0:
	set(new_value):
		minimum = new_value
		value = value


func _init(new_value: float, _maximum: float = 0.0) -> void:
	value = new_value
	maximum = _maximum
