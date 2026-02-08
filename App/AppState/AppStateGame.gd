class_name AppStateGame
extends AppState
## Game State
##
## Indicates that the App is currently in Game Mode, and that the GameState is active.


func enter(_previous_state: SimpleState) -> void:
	if _previous_state is AppStatePause:
		entered.emit()
		return
	
	_enter_normal()
	entered.emit()


func _enter_normal() -> void:
	# Init save game if new game/loading.
	
	# This is a new game.
	Game.state.enter_state(GameStateTest.new())
	
	# We're just resuming. Do nothing.
	entered.emit()
