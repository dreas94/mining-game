class_name PickaxePDAReadyState
extends PickaxePDAState
var move_toward_scale: float = 200.0

func on_state_pushed() -> void:
	move_toward_scale *= UpgradeCollection.calculate_upgrades(UpgradeConstants.TYPE.MINING_SPEED)


func physics_process(delta: float) -> void:
	pda.owner.pickaxe_sprite.rotation_degrees = move_toward(pda.owner.pickaxe_sprite.rotation_degrees, -25.0, 100.0 * delta)
	handle_ray_cast_collision()
	_handle_input(delta)


func _handle_input(_delta: float) -> void:
	if Input.is_action_pressed("mouse_left"):
		return
	
	pop_state_from_stack()


func handle_ray_cast_collision() -> void:
	if not pda.owner.ray_2d.is_colliding():
		return
	
	pda.push_state_to_stack(PickaxePDASwingState.new(pda.owner.ray_2d.get_collider_rid()))
