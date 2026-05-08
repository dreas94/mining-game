class_name PlayerPDAState
extends PushDownAutomataState
var _tween: Tween

func on_state_pushed() -> void:
	_tween = pda.owner.create_tween()
	_tween.set_loops()
	_tween.tween_property(pda.owner.)


func on_state_reactivated() -> void:
	pda.owner.animation_player.play("Idle")


func _start_tween() -> void:
	_tween = pda.owner.create_tween()
	_tween.set_loops()
	_tween.
