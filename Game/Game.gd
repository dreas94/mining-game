# App Autoload Script
class_name GameRoot
extends Node
## Game Autoload
##
## This should be where all Game components are accessible through.
## Use this instead of autoloads, to keep the global namespace clean.

# Should be initialized last.
var state: GameStateMachine = GameStateMachine.new(): set = _set_readonly


@warning_ignore("untyped_declaration")
func _set_readonly(_value) -> void:
	Logger.error(self, _set_readonly, "This property can not be set outside initalization.")
	
	
func _ready() -> void:
	Game.state.enter_state(GameStateNone.new())


func get_save_data() -> Dictionary:
	const VERSION: int = 1
	var data: Dictionary = {}
	return data


func apply_save_data(data: Dictionary) -> void:
	return
