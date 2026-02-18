class_name GameStateTest
extends GameState


func enter(_previous_state: SimpleState) -> void:
	World.active = true
	Interface.item_window.visible = true
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	World.active = false
	exited.emit()
