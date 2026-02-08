class_name AppStateMainMenu
extends AppState
## Main Menu State
##
## Enables and disables the Main Menu
## Part of the Boot > MainMenu > Load/Game sequence.


func enter(_previous_state: SimpleState) -> void:
	App.can_save = true
	Interface.main_menu.enabled = true
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	Interface.main_menu.enabled = false
	exited.emit()
