class_name AppUserSaveProfile
extends RefCounted

const PROFILE_DIRECTORY_PATH: String = "user://profile/"
const EXTENSION: String = ".save"
const USER_DATA_FILE_NAME: String = "user" + EXTENSION
const PATH_DELIMITER: String = "/"

var name: String:
	get:
		if absolute_path:
			var split: PackedStringArray = absolute_path.split(PATH_DELIMITER, false)
			if split.size() > 1:
				return split[-1]
		return ""

var absolute_path: String
var user_data: AppSaveData = AppSaveData.new()
var user_data_file_path: String:
	get: return absolute_path.path_join(USER_DATA_FILE_NAME)

var _userdata_file: AppSaveFile
var _all_save_files: Array[AppSaveFile] = []
var _autosave_files: Array[AppSaveFile]:
	get:
		var a: Array[AppSaveFile] = []
		for file: AppSaveFile in _all_save_files:
			if file.type == AppSaveFile.TYPE.AUTOSAVE:
				a.append(file)
		return a
var _quicksave_files: Array[AppSaveFile]:
	get:
		var a: Array[AppSaveFile] = []
		for file: AppSaveFile in _all_save_files:
			if file.type == AppSaveFile.TYPE.QUICKSAVE:
				a.append(file)
		return a


func _init() -> void:
	absolute_path = PROFILE_DIRECTORY_PATH
	DirAccess.make_dir_recursive_absolute(absolute_path)
	
	_userdata_file = AppSaveFile.new(user_data_file_path, AppSaveFile.TYPE.OTHER)
	user_data.stage_save_file(_userdata_file)
	user_data.stage_int("last_changed", int(Time.get_unix_time_from_system()))
	_load_all_saves()


func _load_all_saves() -> void:
	var files: PackedStringArray = DirAccess.get_files_at(absolute_path)
	for file_name: String in files:
		
		if file_name == USER_DATA_FILE_NAME:
			continue
		
		var full_path: String = absolute_path.path_join(file_name)
		var save_file: AppSaveFile = AppSaveFile.new(full_path)
		_all_save_files.append(save_file)


func save_user_data() -> void:
	_userdata_file.put_data(user_data.get_data())
	_userdata_file.save_to_disk()


func delete_save(save_file: AppSaveFile) -> void:
	if save_file == _userdata_file:
		return
	var save_belongs_to_this_profile: bool = false
	if save_file in _autosave_files:
		save_belongs_to_this_profile = true
	if save_file in _quicksave_files:
		save_belongs_to_this_profile = true
	if save_file in _all_save_files:
		save_belongs_to_this_profile = true
		_all_save_files.erase(save_file)
	
	if save_belongs_to_this_profile:
		save_file.delete_from_disk()


func delete_forever() -> void:
	# BUG: This actually causes an error on windows, but does delete the file.
	OS.move_to_trash(absolute_path)
	for i: int in get_reference_count():
		unreference()


func get_autosaves() -> Array[AppSaveFile]:
	return _autosave_files.duplicate()


func get_quick_saves() -> Array[AppSaveFile]:
	return _quicksave_files.duplicate()


func get_all_save_files() -> Array[AppSaveFile]:
	return _all_save_files.duplicate()


func has_file(save_file: AppSaveFile) -> bool:
	return save_file in _all_save_files


func save_to_file(save_file: AppSaveFile, data: Dictionary) -> void:
	if not has_file(save_file):
		Logger.error(self, save_to_file, "Can't save. File does not belong to profile.")
		return
	save_file.put_data(data)
	save_file.save_to_disk()


func save_to_new_file(data: Dictionary) -> AppSaveFile:
	var file_name: String = str(int(Time.get_unix_time_from_system())) + EXTENSION
	var file_path: String = absolute_path.path_join(file_name)
	var save_file: AppSaveFile = AppSaveFile.new(file_path, AppSaveFile.TYPE.SAVE)
	_all_save_files.append(save_file)
	save_file.put_data(data)
	save_file.save_to_disk()
	return save_file


func save_to_last_file(data: Dictionary) -> void:
	if _all_save_files.is_empty():
		save_to_new_file(data)
		return
	
	var files_reversed: Array[AppSaveFile] = _all_save_files.duplicate()
	files_reversed.reverse()
	
	for save_file: AppSaveFile in files_reversed:
		if save_file.type == AppSaveFile.TYPE.SAVE:
			save_to_file(save_file, data)
			return
	
	# This is only reachable if there's no normal save file.
	save_to_new_file(data)


func save_to_autosave(data: Dictionary) -> void:
	# Save to a new file
	var file_name: String = str(int(Time.get_unix_time_from_system())) + EXTENSION
	var file_path: String = absolute_path.path_join(file_name)
	var save_file: AppSaveFile = AppSaveFile.new(file_path, AppSaveFile.TYPE.AUTOSAVE)
	_all_save_files.append(save_file)
	save_file.put_data(data)
	save_file.save_to_disk()
	
	var autosaves: Array[AppSaveFile] = _autosave_files
	if autosaves.size() > 3:
		# Delete the oldest autosave, which should be the first in the list.
		var save_to_override: AppSaveFile = autosaves[0]
		for save: AppSaveFile in autosaves:
			if save.creation_time < save_to_override.creation_time:
				save_to_override = save
	
		delete_save(save_to_override)


func save_to_quicksave(data: Dictionary) -> void:
	# Save to a new file
	var file_name: String = str(int(Time.get_unix_time_from_system())) + EXTENSION
	var file_path: String = absolute_path.path_join(file_name)
	var save_file: AppSaveFile = AppSaveFile.new(file_path, AppSaveFile.TYPE.QUICKSAVE)
	_all_save_files.append(save_file)
	save_file.put_data(data)
	save_file.save_to_disk()
	
	var quicksaves: Array[AppSaveFile] = _quicksave_files
	if quicksaves.size() > 3:
		# Delete the oldest quicksave, which should be the first in the list.
		var save_to_override: AppSaveFile = quicksaves[0]
		for save: AppSaveFile in quicksaves:
			if save.creation_time < save_to_override.creation_time:
				save_to_override = save
	
		delete_save(save_to_override)
