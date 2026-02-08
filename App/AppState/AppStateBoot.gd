class_name AppStateBoot
extends AppState
## Boot State
##
## Initializes RNG and transitions to the Main Menu.
## This where you might implement splash screens, logos, and background loading.


func enter(_previous_state: SimpleState) -> void:
	App.save.clear()
	
	entered.emit()
	App.state.enter_state(AppStateMainMenu.new())
