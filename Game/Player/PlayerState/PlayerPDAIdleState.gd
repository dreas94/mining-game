class_name PlayerPDAIdleState
extends PlayerPDAState


func on_state_pushed() -> void:
	pda.owner.animation_player.play("Idle")


func on_state_reactivated() -> void:
	pda.owner.animation_player.play("Idle")


func physics_process(delta) -> void:
	if pda.owner.move_direction != 0:
		pda.push_state_to_stack(PlayerPDAWalkState.new())
		return
	
	if Input.is_action_pressed("jump") and pda.owner.is_on_floor():
		pda.push_state_to_stack(PlayerPDAJumpState.new())
	
	var velocity_x: float = pda.owner.velocity.x
	var deacceleration: float = pda.owner.deacceleration
	
	pda.owner.velocity.x = move_toward(velocity_x, 0.0, deacceleration * delta)
	super(delta)
