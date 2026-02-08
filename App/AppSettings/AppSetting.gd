class_name AppSetting
extends RefCounted
## Base class for App Settings
##
## Extend this class to create a setting, and register it in AppSettings.
## Refer to other Settings for implementation details.
## Should implement a reset, reset to default, and apply, function.

@warning_ignore("unused_signal")
signal current_changed
@warning_ignore("unused_signal")
signal staged_changed


func get_cfg_section() -> String:
	Logger.error(self, get_cfg_section, "Not implemented in extended class.")
	return ""


func get_cfg_key() -> String:
	Logger.error(self, get_cfg_key, "Not implemented in extended class.")
	return ""


@warning_ignore("untyped_declaration")
func get_default(): # -> Any:
	Logger.error(self, get_default, "Not implemented in extended class.")
	return null


@warning_ignore("untyped_declaration")
func get_current(): # -> Any:
	Logger.error(self, get_current, "Not implemented in extended class.")
	return null


@warning_ignore("untyped_declaration")
func set_stored(_value) -> void:
	pass


func reset_to_default() -> void:
	Logger.error(self, reset_to_default, "Not implemented in extended class.")


func reset_to_stored() -> void:
	Logger.error(self, reset_to_stored, "Not implemented in extended class.")


func apply_current() -> void:
	Logger.error(self, apply_current, "Not implemented in extended class.")


func move_staged_to_current() -> void:
	Logger.error(self, move_staged_to_current, "Not implemented in extended class.")
