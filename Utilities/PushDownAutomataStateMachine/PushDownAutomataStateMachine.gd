class_name PushDownAutomataStateMachine
extends RefCounted

var owner: Node2D
var state_stack: Array[PushDownAutomataState] = []


func push_state_to_stack(new_state: PushDownAutomataState) -> void:
	if not state_stack.is_empty():
		state_stack[-1].on_state_deactivated()
	
	new_state.pda = self
	
	state_stack.append(new_state)
	
	new_state.on_state_pushed()


func pop_state_from_stack() -> void:
	if state_stack.is_empty():
		return
	var popped_state: PushDownAutomataState = state_stack.pop_back()
	popped_state.on_state_popped()
	if not state_stack.is_empty():
		state_stack[-1].on_state_reactivated()


func clear_stack() -> void:
	while not state_stack.is_empty():
		pop_state_from_stack()


func _physics_update(delta):
	if state_stack.is_empty():
		return
	
	state_stack[-1].physics_process(delta)
