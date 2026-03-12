class_name AppStateLose
extends AppState
## Pause State
## 
## Entered from within the Game State.
## Pause the game here and display the pause menu.


func enter(_previous_state: SimpleState) -> void:
	Interface.lose_menu.enabled = true
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	Interface.lose_menu.enabled = false
	exited.emit()
