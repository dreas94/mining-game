class_name Transitions
extends MarginContainer

signal none_completed

enum STYLE {FADE, FILL}

const FADE_SCENE: PackedScene = preload("uid://cqrfecj2jytt6")
const FILL_SCENE: PackedScene = preload("uid://bmf1sc4d0ro6q")

var _fade: iFadeTransition
var _fill: iFillTransition


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE
	add_theme_constant_override("margin_left", 0)
	add_theme_constant_override("margin_right", 0)
	add_theme_constant_override("margin_up", 0)
	add_theme_constant_override("margin_down", 0)
	
	_fade = FADE_SCENE.instantiate()
	_fill = FILL_SCENE.instantiate()
	add_child(_fade)
	add_child(_fill)


func to_black(style: STYLE = STYLE.FADE) -> Signal:
	match style:
		STYLE.FADE:
			return _fade.transition_in(false)
		STYLE.FILL:
			return _fill.transition_in()
	
	none_completed.emit.call_deferred()
	return none_completed


func to_clear(style: STYLE = STYLE.FADE) -> Signal:
	match style:
		STYLE.FADE:
			return _fade.transition_out(true)
		STYLE.FILL:
			return _fill.transition_out(true)
	
	none_completed.emit.call_deferred()
	return none_completed
