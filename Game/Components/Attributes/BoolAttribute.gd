class_name BoolAttribute
extends RefCounted

signal changed(bool_value: bool, previous_value: bool)

var value: bool:
	set(new_value):
		var old_value: bool = _value
		if new_value != old_value:
			_value = new_value
			changed.emit(new_value, old_value)
	get:
		return _value
var _value: bool = false


func _init(new_value: bool) -> void:
	value = new_value


func set_silent(new_value: bool) -> void:
	_value = new_value
