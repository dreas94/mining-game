class_name PushDownAutomataState
extends RefCounted

var pda: PushDownAutomataStateMachine = null


# This is called when the stack has been initialized and added
# to the stack.
func on_state_pushed() -> void:
	pass


# This is called when the stack has just been popped from the
# stack, but before it is deleted with queue_free().
func on_state_popped() -> void:
	pass


# This is called when the state on top of this state has just
# been popped.
func on_state_reactivated() -> void:
	pass


# This is ticked every physics frame, going from the state
# at the bottom of the stack towards the one on top.
func physics_process(_delta) -> void:
	pass

# The following are convinience methods so that it is easier to 
# push and pop the states within the stackable states.
func push_state_to_stack(new_state: PushDownAutomataState) -> void:
	pda.push_state_to_stack(new_state)


func pop_state_from_stack() -> void:
	pda.pop_state_from_stack()
