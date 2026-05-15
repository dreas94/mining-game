class_name PickaxePDARecoveryState
extends PickaxePDAState
var _original_color: Color = Color(0.635, 0.161, 0.0)
var _final_color: Color = Color(0.416, 0.416, 0.416)
var _tween_time: float = 1.0
var _tween: Tween

func on_state_pushed() -> void:
	_tween_time /= UpgradeCollection.calculate_upgrades(UpgradeConstants.TYPE.MINING_SPEED)
	_start_tween()


func on_state_popped() -> void:
	_stop_tween()


func on_state_deactivated() -> void:
	_stop_tween()


func _stop_tween() -> void:
	if _tween == null:
		return
	if not _tween.is_running():
		return
	
	_tween.stop()
	_tween = null


func _start_tween() -> void:
	if _tween != null and _tween.is_running():
		_tween.stop()
		_tween = null
	
	_tween = pda.owner.create_tween()
	_tween.set_parallel(true)
	_tween.tween_property(pda.owner.pickaxe_sprite,"modulate", _final_color, _tween_time).from(_original_color)
	_tween.tween_callback(pop_state_from_stack).set_delay(_tween_time)
