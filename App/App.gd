# App Autoload Script
class_name AppRoot
extends Node
## App Autoload
##
## This should be where all App components are accessible through.
## Use this instead of autoloads, to keep the global namespace clean.

var config: AppConfig = load("res://app_config.tres"): set = _set_readonly
var settings: AppSettings = AppSettings.new(): set = _set_readonly
var save: AppSave = AppSave.new(): set = _set_readonly

var sfx: SFXPlayer = SFXPlayer.new(self): set = _set_readonly
var music: MusicPlayer = MusicPlayer.new(self): set = _set_readonly
# Should be initialized last.
var state: AppStateMachine = AppStateMachine.new(): set = _set_readonly

var can_save: bool = true

var can_pause: bool = false
var is_paused: bool:
	get: return state.active_state is AppStatePause


@warning_ignore("untyped_declaration")
func _set_readonly(_value) -> void:
	Logger.error(self, _set_readonly, "This property can not be set outside initalization.")


func _ready() -> void:
	state.tree = get_tree()
	state.enter_state(AppStateNone.new())
