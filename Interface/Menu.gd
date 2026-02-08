class_name Menu
extends Control


var enabled: bool = false:
	set(value):
		if value != enabled:
			enabled = value
		
		if enabled:
			_enable()
		else:
			_disable()


func _init() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = false


func _enable() -> void:
	# Put your Code here.
	pass


func _disable() -> void:
	# Put your Code here.
	pass
