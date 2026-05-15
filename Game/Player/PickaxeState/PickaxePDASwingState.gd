class_name PickaxePDASwingState
extends PickaxePDAState
var _tween: Tween
var _rid: RID
var _tween_time: float = 0.5
var _original_color: Color = Color(0.416, 0.416, 0.416)
var _final_color: Color = Color(0.635, 0.161, 0.0)

func _init(rid: RID) -> void:
	_rid = rid


func on_state_pushed() -> void:
	_tween_time /= pda.owner.mining_speed
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


func on_state_reactivated() -> void:
	pda.pop_state_from_stack()


func _start_tween() -> void:
	if _tween != null and _tween.is_running():
		_tween.stop()
		_tween = null
	
	_tween = pda.owner.create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.set_parallel()
	_tween.tween_property(pda.owner.pickaxe_sprite, "rotation_degrees", 50.0, _tween_time * 0.5).from(-25.0)
	_tween.tween_property(pda.owner.pickaxe_sprite, "rotation_degrees", -25, _tween_time * 0.5).from(50.0).set_delay(_tween_time * 0.5)
	_tween.tween_property(pda.owner.pickaxe_sprite,"modulate", _final_color, _tween_time).from(_original_color)
	_tween.tween_callback(_attempt_to_mine_by_rid.bind(_rid)).set_delay(_tween_time * 0.5)
	_tween.tween_callback(pda.push_state_to_stack.bind(PickaxePDARecoveryState.new())).set_delay(_tween_time)


func _attempt_to_mine_by_rid(rid_to_mine: RID) -> void:
	Health.sub_health(randf_range(1.0, 5.0))
	var damage: float = pda.owner.mining_power
	pda.owner.mine_attempt_by_rid.emit(damage, rid_to_mine)
	
