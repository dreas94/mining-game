class_name GameStateNone
extends GameState
## None State
##
## App State is initialized with this state. It does nothing.

func enter(_previous_state: SimpleState) -> void:
	ItemCollection.clear()
	await Interface.transitions.to_clear(Transitions.STYLE.FADE)
	entered.emit()
