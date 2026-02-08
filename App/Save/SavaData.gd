class_name AppSaveData
extends RefCounted

var _data: Dictionary = {}


func get_data(deep_copy: bool = false) -> Dictionary:
	return _data.duplicate(deep_copy)


func stage_bool(id: String, value: bool, yes_override_please: bool = false) -> void:
	if id in _data and not _data[id] is bool and not yes_override_please:
		Logger.error(self, stage_bool, "Overrode %s with %s" % [_data[id], value])
	_data[id] = value


func stage_int(id: String, value: int, yes_override_please: bool = false) -> void:
	if id in _data and not _data[id] is int and not yes_override_please:
		Logger.error(self, stage_bool, "Overrode %s with %s" % [_data[id], value])
	_data[id] = value


func stage_float(id: String, value: float, yes_override_please: bool = false) -> void:
	if id in _data and not _data[id] is float and not yes_override_please:
		Logger.error(self, stage_bool, "Overrode %s with %s" % [_data[id], value])
	_data[id] = value


func stage_string(id: String, value: String, yes_override_please: bool = false) -> void:
	if id in _data and not _data[id] is String and not yes_override_please:
		Logger.error(self, stage_bool, "Overrode %s with %s" % [_data[id], value])
	_data[id] = value


func stage_array(id: String, value: Array, yes_override_please: bool = false) -> void:
	if id in _data and not _data[id] is Array and not yes_override_please:
		Logger.error(self, stage_bool, "Overrode %s with %s" % [_data[id], value])
	_data[id] = value


func stage_dict(id: String, value: Dictionary, yes_override_please: bool = false) -> void:
	if id in _data and not _data[id] is Dictionary and not yes_override_please:
		Logger.error(self, stage_bool, "Overrode %s with %s" % [_data[id], value])
	_data[id] = value


func stage_save_file(save_file: AppSaveFile) -> void:
	_data = save_file.get_data()


func get_bool(id: String, default: bool = false) -> bool:
	if not id in _data:
		return default
	if not _data[id] is bool:
		Logger.warn(self, get_int, "Value isn't a bool.")
		return default
	return _data[id]


func get_int(id: String, default: int = 0) -> int:
	if not id in _data:
		return default
	if not _data[id] is int:
		Logger.warn(self, get_int, "Value isn't an int.")
		return default
	return _data[id]


func get_float(id: String, default: float = 0.0) -> float:
	if not id in _data:
		return default
	if not _data[id] is float:
		Logger.warn(self, get_float, "Value isn't a float.")
		return default
	return _data[id]


func get_string(id: String, default: String = "") -> String:
	if not id in _data:
		return default
	if not _data[id] is String:
		Logger.warn(self, get_string, "Value isn't a String.")
		return default
	return _data[id]


func get_array(id: String, default: Array = []) -> Array:
	if not id in _data:
		return default
	if not _data[id] is Array:
		Logger.warn(self, get_array, "Value isn't an Array.")
		return default
	return _data[id]


func get_dict(id: String, default: Dictionary = {}) -> Dictionary:
	if not id in _data:
		return default
	if not _data[id] is Dictionary:
		Logger.warn(self, get_dict, "Value isn't a Dictionary.")
		return default
	return _data[id]


func has_bool(id: String) -> bool:
	return (id in _data and _data[id] is bool)


func has_int(id: String) -> bool:
	return (id in _data and _data[id] is int)


func has_float(id: String) -> bool:
	return (id in _data and _data[id] is float)


func has_string(id: String) -> bool:
	return (id in _data and _data[id] is String)


func has_array(id: String) -> bool:
	return (id in _data and _data[id] is Array)


func has_dict(id: String) -> bool:
	return (id in _data and _data[id] is Dictionary)


func clear() -> void:
	_data = {}
