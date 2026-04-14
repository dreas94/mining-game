class_name GameStateCamp
extends GameState


func enter(_previous_state: SimpleState) -> void:
	Camp.active = true
	await Interface.transitions.to_clear(Transitions.STYLE.FADE)
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	await Interface.transitions.to_black(Transitions.STYLE.FILL)
	Camp.active = false
	exited.emit()
