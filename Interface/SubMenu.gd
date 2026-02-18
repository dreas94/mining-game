class_name SubMenu
extends PanelContainer

@warning_ignore("unused_signal")
signal opened
signal closed(result: Result)


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		_enabled()
	else:
		_disabled()


func _enabled() -> void:
	# Called when SubMenu becomes Visible. Put your Code here.
	pass


func _disabled() -> void:
	# Called when SubMenu becomes InVisible. Put your Code here.
	pass


func close(result: Result = Result.new()) -> void:
	closed.emit(result)


class Result extends RefCounted:
	
	var status: int = OK
	
	func _init(_status: int = OK) -> void:
		status = _status
