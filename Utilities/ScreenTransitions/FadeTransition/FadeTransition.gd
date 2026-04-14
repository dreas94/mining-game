@tool
class_name iFadeTransition
extends ScreenTransition

@export var fade_time: float = 1.0
@export var color_rect: ColorRect


func _transition_in(hide_when_completed: bool = false) -> void:
	visible = true
	
	color_rect.color = Color.BLACK
	color_rect.color.a = 0.0
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), fade_time)
	await t.finished
	
	visible = not hide_when_completed
	transition_in_completed.emit()


func _transition_out(hide_when_completed: bool = false) -> void:
	visible = true
	
	color_rect.color = Color.BLACK
	color_rect.color.a = 1.0
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), fade_time)
	await t.finished
	
	visible = not hide_when_completed
	# Always emit this when done.
	transition_out_completed.emit()
