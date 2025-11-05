class_name IntAttribute
extends RefCounted

signal changed(int_value: int, int_delta: int)

var value: int:
	set(new_value):
		new_value = min(new_value, maximum) if maximum != 0 else new_value
		var old_value: int = _value
		if new_value != old_value:
			_value = new_value
			changed.emit(new_value, -(old_value - new_value))
	get:
		return _value
var _value: int = 0
var maximum: int = 0:
	set(new_value):
		maximum = new_value
		value = value


func _init(new_value: int, _maximum: int = 0) -> void:
	value = new_value
	maximum = _maximum


func set_value_silent(new_value: int) -> void:
	_value = min(new_value, maximum) if maximum != 0 else new_value


func set_maximum_silent(_maximum: int) -> void:
	maximum = _maximum
	set_value_silent(value)
