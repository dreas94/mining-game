class_name AppStateLoad
extends AppState
## Load State
##
## Enter this state when loading a SaveGame.
## Loads and applies a save game, then transitions into AppStateGame.

var save_file: AppSaveFile


func _init(_save_file: AppSaveFile) -> void:
	save_file = _save_file


func enter(_previous_state: SimpleState) -> void:
	#iCardTooltip.kill_all.set_true(self)
	Logger.hint(self, enter)
	
	App.can_save = false
	entered.emit()
	
	App.save.apply_saved_data()
	
	#Game.state.enter_state(GameStateCamp.new())
