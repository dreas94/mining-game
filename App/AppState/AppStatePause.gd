class_name AppStatePause
extends AppState
## Pause State
## 
## Entered from within the Game State.
## Pause the game here and display the pause menu.


func enter(_previous_state: SimpleState) -> void:
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	exited.emit()
