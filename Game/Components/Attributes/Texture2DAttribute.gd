class_name Texture2DAttribute
extends RefCounted

signal changed(string_value: String)

var value: Texture2D:
	set(new_value):
		var old_value: Texture2D = _value
		if new_value != old_value:
			_value = new_value
			changed.emit(new_value)
	get:
		return _value
var _value: Texture2D


func _init(new_value: Texture2D) -> void:
	value = new_value


func set_silent(new_value: Texture2D) -> void:
	_value = new_value
