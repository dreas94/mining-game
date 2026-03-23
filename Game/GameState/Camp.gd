class_name GameStateCamp
extends GameState


func enter(_previous_state: SimpleState) -> void:
	Camp.active = true
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	Camp.active = false
	exited.emit()
