class_name AppSaveFile
extends RefCounted

enum DATA_MODE {RAW, TEXT} # Text = Json
var data_mode: DATA_MODE = DATA_MODE.TEXT
enum DELETE_MODE {MOVE_TO_TRASH, FOREVER}
var delete_mode: DELETE_MODE = DELETE_MODE.FOREVER
enum TYPE {NONE, SAVE, QUICKSAVE, AUTOSAVE, OTHER}
var type: TYPE = TYPE.NONE
var format_version: int = -1

var absolute_path: String:
	get: return _absolute_path
var creation_time: int:
	get:
		return int(_data.time_saved_at)
var creation_time_string: String:
	get:
		var s: String = Time.get_datetime_string_from_unix_time(_data.time_saved_at, true)
		return s

var _absolute_path: String = ""
var _data: Dictionary = {}


func _init(abs_path: String, _type: TYPE = TYPE.NONE) -> void:
	_absolute_path = abs_path
	type = _type
	load_from_disk.call_deferred()


func load_from_disk() -> void:
	if not FileAccess.file_exists(_absolute_path):
		_data = {}
		return
	
	var file: FileAccess = FileAccess.open(_absolute_path, FileAccess.READ)
	var data: Dictionary = {}
	
	match data_mode:
		DATA_MODE.RAW:
			data = file.get_var()
		DATA_MODE.TEXT:
			data = JSON.parse_string(file.get_line())
	
	file.close()
	
	if not data.save_format_version == App.config.save_file_format_version:
		var msg: String = "Save is format %s, game is %s."
		msg = msg % [data.save_format_version, App.config.save_file_format_version]
		Logger.warn(self, load_from_disk, msg)
		# TODO: Implement conversion steps here.
	
	_data = data
	type = _data.save_type
	format_version = _data.save_format_version


func save_to_disk() -> void:
	DirAccess.make_dir_recursive_absolute(_absolute_path.get_base_dir())
	var file: FileAccess = FileAccess.open(_absolute_path, FileAccess.WRITE)
	
	_data.time_saved_at = int(Time.get_unix_time_from_system())
	_data.save_format_version = App.config.save_file_format_version
	_data.save_type = type
	
	match data_mode:
		DATA_MODE.RAW:
			file.store_var(_data)
		DATA_MODE.TEXT:
			var text_data: String = JSON.stringify(_data)
			file.store_line(text_data)
	
	file.close()


	# DO NOT CALL THIS OUTSIDE OF Profile.delete_file()
func delete_from_disk() -> void:
	if delete_mode == DELETE_MODE.MOVE_TO_TRASH:
		OS.move_to_trash(_absolute_path)
	else:
		DirAccess.remove_absolute(_absolute_path)
	for i: int in get_reference_count():
		unreference()


func put_data(new_data: Dictionary) -> void:
	_data = new_data


func get_data() -> Dictionary:
	return _data.duplicate(true)
