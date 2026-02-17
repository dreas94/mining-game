class_name AnyAttribute
extends RefCounted

@warning_ignore("untyped_declaration")
signal changed(new_value, previous_value)

@warning_ignore("untyped_declaration")
var value:
	set(new_value):
		if new_value != value:
			@warning_ignore("untyped_declaration")
			var old_value = value
			_value = new_value
			changed.emit(new_value, old_value)
	get:
		return _value
@warning_ignore("untyped_declaration")
var _value


@warning_ignore("untyped_declaration")
func _init(new_value) -> void:
	value = new_value


@warning_ignore("untyped_declaration")
func set_value_silent(new_value) -> void:
	_value = new_value
