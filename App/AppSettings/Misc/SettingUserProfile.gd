class_name AppSettingUserProfile
extends AppSetting

const CFG_SECTION: String = "user"
const CFG_KEY: String = "profile"
const DEFAULT: String = "default"

var stored: String = DEFAULT

var current: String = DEFAULT:
	set(value):
		current = value
		apply_current()
		current_changed.emit()

var staged: String = DEFAULT:
	set(value):
		staged = value
		staged_changed.emit()
		# Only do this when you know applying settings like this is safe.
		current = value

var _last_applied: String = DEFAULT


func get_cfg_section() -> String:
	return CFG_SECTION


func get_cfg_key() -> String:
	return CFG_KEY


@warning_ignore("untyped_declaration")
func get_default(): # -> Any:
	return DEFAULT


@warning_ignore("untyped_declaration")
func get_current(): # -> Any:
	return current


@warning_ignore("untyped_declaration")
func set_stored(_value) -> void:
	if _value is String:
		stored = _value
		staged = _value


func reset_to_default() -> void:
	current = DEFAULT


func reset_to_stored() -> void:
	current = stored


func apply_current() -> void:
	if current == _last_applied:
		return
	_last_applied = current
	# Intentionally nothing. The profile manager handles this stuff.
	pass


func move_staged_to_current() -> void:
	current = staged
