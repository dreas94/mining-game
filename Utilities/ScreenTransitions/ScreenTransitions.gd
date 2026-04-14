@tool
class_name ScreenTransition
extends Control

signal transition_in_completed
signal transition_out_completed


func _ready() -> void:
	visible = false


func transition_in(hide_when_completed: bool = false) -> Signal:
	_transition_in.call_deferred(hide_when_completed)
	return transition_in_completed


func transition_out(hide_when_completed: bool = false) -> Signal:
	_transition_out.call_deferred(hide_when_completed)
	return transition_out_completed


func _transition_in(hide_when_completed: bool = false) -> void:
	visible = true
	
	visible = not hide_when_completed
	transition_in_completed.emit()


func _transition_out(hide_when_completed: bool = false) -> void:
	visible = true
	
	visible = not hide_when_completed
	transition_out_completed.emit()
