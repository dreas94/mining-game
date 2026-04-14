@tool
class_name iFillTransition
extends ScreenTransition

@export var fade_time: float = 1.5
@export var progress_bar: ProgressBar


func _transition_in(hide_when_completed: bool = false) -> void:
	visible = true
	
	progress_bar.self_modulate = Color.BLACK
	progress_bar.value = 0.0
	
	var t: Tween = create_tween()
	t.tween_property(progress_bar, "value", 100.0, fade_time)
	await t.finished
	
	visible = not hide_when_completed
	transition_in_completed.emit()


func _transition_out(hide_when_completed: bool = false) -> void:
	visible = true
	
	progress_bar.self_modulate = Color.BLACK
	progress_bar.value = 100.0
	
	var t: Tween = create_tween()
	t.tween_property(progress_bar, "value", 0.0, fade_time)
	await t.finished
	
	visible = not hide_when_completed
	# Always emit this when done.
	transition_out_completed.emit()
