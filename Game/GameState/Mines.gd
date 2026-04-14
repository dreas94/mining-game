class_name GameStateMines
extends GameState


func enter(_previous_state: SimpleState) -> void:
	Mines.active = true
	await Interface.transitions.to_clear(Transitions.STYLE.FILL)
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	await Interface.transitions.to_black(Transitions.STYLE.FADE)
	Mines.active = false
	exited.emit()
