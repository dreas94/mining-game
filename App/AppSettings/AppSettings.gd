class_name AppSettings
extends RefCounted
## AppSettings Autoload
##
## Responsible for saving, loading, and applying, application level settings.
## Ex.: Resolution, window mode, master audio.
## Should be the first one in the list always.

const APP_CONFIG: AppConfig = preload("uid://c1626k6v5xndh")
const CFG_PATH: String = "user://app_settings.cfg"
const META_SECTION: String = "meta"
const VERSION_KEY: String = "version"

enum PLATFORMS {INVALID, WINDOWS, MACOS, LINUX, ANDROID, IOS, WEB}
var platform: PLATFORMS = PLATFORMS.INVALID

	# This determines the order in which setings are applied.
var _settings: Array[AppSetting] = []

var _cfg_file: ConfigFile


func _init() -> void:
	_init_platform()
	_ensure_dir_exists()
	_init_file()


func _init_platform() -> void:
	var os_name: String = OS.get_name()
	match os_name:
		"Windows": platform = PLATFORMS.WINDOWS
		"UWP": platform = PLATFORMS.WINDOWS
		"macOS": platform = PLATFORMS.MACOS
		"Linux": platform = PLATFORMS.LINUX
		"FreeBSD": platform = PLATFORMS.LINUX
		"NetBSD": platform = PLATFORMS.LINUX
		"OpenBSD": platform = PLATFORMS.LINUX
		"BSD": platform = PLATFORMS.LINUX
		"Android": platform = PLATFORMS.ANDROID
		"iOS": platform = PLATFORMS.IOS
		"Web": platform = PLATFORMS.WEB


func _init_file() -> void:
	
	if FileAccess.file_exists(CFG_PATH):
		Logger.hint(self, _init_file, "Loading config file.")
		_cfg_file = ConfigFile.new()
		_cfg_file.load(CFG_PATH)
		return
	
	else:
		Logger.hint(self, _init_file, "Creating config file.")
		_cfg_file = ConfigFile.new()
		_cfg_file.set_value(META_SECTION, VERSION_KEY, 0)
		_cfg_file.save(CFG_PATH)
	
	# If the version is wrong, reset the settings
	if _cfg_file.get_value(META_SECTION, VERSION_KEY, 0) != APP_CONFIG.settings_file_version:
		Logger.hint(self, _init_file, "Config version %s, game version %s. Resetting to defaults.")
		_cfg_file = ConfigFile.new()
		_cfg_file.save(CFG_PATH)


func _ensure_dir_exists() -> void:
	if not DirAccess.dir_exists_absolute(OS.get_user_data_dir()):
		DirAccess.make_dir_recursive_absolute(OS.get_user_data_dir())


func load_stored() -> void:
	for setting: AppSetting in _settings:
		var section: String = setting.get_cfg_section()
		var key: String = setting.get_cfg_key()
		@warning_ignore("untyped_declaration")
		var default = setting.get_default()
		
		@warning_ignore("untyped_declaration")
		var value = _cfg_file.get_value(section, key, default)
		
		@warning_ignore("unsafe_property_access")
		if not typeof(value) == typeof(setting.current):
			Logger.warn(self, load_stored, "%s %s value is not of correct type." % [section, key])
			break
		
		setting.set_stored(value)
		@warning_ignore("unsafe_property_access")
		setting.current = value


func save_current() -> void:
	for setting: AppSetting in _settings:
		var section: String = setting.get_cfg_section()
		var key: String = setting.get_cfg_key()
		@warning_ignore("untyped_declaration")
		var value = setting.get_current()
		_cfg_file.set_value(section, key, value)
		setting.set_stored(setting.get_current())
	
	_cfg_file.set_value(META_SECTION, VERSION_KEY, App.config.settings_file_version)
	_cfg_file.save(CFG_PATH)


func reset_to_default() -> void:
	for setting: AppSetting in _settings:
		setting.reset_to_default()
	save_current()


func reset_to_stored() -> void:
	for setting: AppSetting in _settings:
		setting.reset_to_stored()
	save_current()


func apply_staged_changes() -> void:
	for setting: AppSetting in _settings:
		setting.move_staged_to_current()
	save_current()
