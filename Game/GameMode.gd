class_name GameMode
extends Node2D

signal enabled
signal disabled


var active: bool = false:
	set(value):
		if value != active:
			active = value
			
			if active:
				_enabled()
			else:
				_disabled()


func _enabled() -> void:
	enabled.emit()


func _disabled() -> void:
	disabled.emit()
