class_name AppSave
extends AppSaveData
## App Save
##
## Helper for managing save files inside user profiles.
## Specifically this is a staging area for gathering and retrieving data.

const GAME_AUTOLOAD_NAME: String = "Data"
const GAME_KEY: String = "data"
const GAME_SAVE_FUNC_NAME: String = "get_save_data"
const GAME_LOAD_FUNC_NAME: String = "apply_save_data"


func clear() -> void:
	_data.clear()


func save_to_file(save_file: AppSaveFile) -> void:
	if not App.can_save:
		return
	App.profile.save_to_file(save_file, _data.duplicate())


func save_to_new_file() -> AppSaveFile:
	if not App.can_save:
		return
	return App.profile.save_to_new_file(_data.duplicate())


func save_to_last_file() -> void:
	if not App.can_save:
		return
	App.profile.save_to_last_file(_data.duplicate())


func save_to_quicksave() -> void:
	if not App.can_save:
		return
	App.profile.save_to_quicksave(_data.duplicate())


func save_to_autosave() -> void:
	if not App.can_save:
		return
	App.profile.save_to_autosave(_data.duplicate())


func delete_save(save_file: AppSaveFile) -> void:
	App.profile.delete_save(save_file)


	# Override this with your game specific data gathering if you wish.
	# By default however, this will look for an autoload called 'Game'
	# And grab its data from there.
func gather_data_to_save() -> void:
	var game_autoload: Node = _get_game_autoload()
	if game_autoload and game_autoload.has_method(GAME_SAVE_FUNC_NAME):
		var data: Dictionary = game_autoload.call(GAME_SAVE_FUNC_NAME)
		stage_dict(GAME_KEY, data)


func apply_saved_data() -> void:
	if not App.can_save:
		return
	var game_autoload: Node = _get_game_autoload()
	if game_autoload and game_autoload.has_method(GAME_LOAD_FUNC_NAME):
		var game_data: Dictionary = get_dict(GAME_KEY, {})
		game_autoload.call(GAME_LOAD_FUNC_NAME, game_data)


func _get_game_autoload() -> Node:
	var root: Node = App.get_tree().root
	var game_autoload: Node = null
	for child: Node in root.get_children():
		if child.name == GAME_AUTOLOAD_NAME:
			game_autoload = child
			break
	return game_autoload
