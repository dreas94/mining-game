class_name AppStateMachine
extends SimpleStateMachine
## AppState Autoload
##
## A state machine to handle application states.
## Refer to the individual states for implementation details.
## When running the game, the first thing that should be done is to enter a new state.
## For example, boot.gd will call 'enter_state(AppsStateBoot.new())'


func enter_state(new_state: SimpleState) -> void:
	_enter_state(new_state)
