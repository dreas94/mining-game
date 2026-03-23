class_name GameStateMines
extends GameState


func enter(_previous_state: SimpleState) -> void:
	Mines.active = true
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	Mines.active = false
	exited.emit()
