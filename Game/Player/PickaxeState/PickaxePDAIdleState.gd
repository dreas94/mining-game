class_name PickaxePDAIdleState
extends PickaxePDAState

var _tween: Tween


func on_state_pushed() -> void:
	_start_tween()


func on_state_popped() -> void:
	_stop_tween()
	var tile: Tile = Mines.tile_handler.get_tile_in_grid_position(pda.owner.last_tile_grid_pos_ray_casted)
	if tile == null:
		return
	
	
	tile.tile_attributes.is_moused.value = false


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
	_start_tween()


func _start_tween() -> void:
	if _tween != null and _tween.is_running():
		_tween.stop()
		_tween = null
	
	_tween = pda.owner.create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_loops()
	_tween.tween_property(pda.owner.pickaxe_sprite, "rotation_degrees", 25.0, 1.5).from(0.0)
	_tween.tween_property(pda.owner.pickaxe_sprite, "rotation_degrees", 0, 1.5).from(25.0)


func physics_process(_delta: float) -> void:
	_handle_input()


func _handle_input() -> void:
	if Game.state.active_state is GameStateCamp:
		return
	
	if not Input.is_action_pressed("mouse_left"):
		return
	
	pda.push_state_to_stack(PickaxePDAReadyState.new())
